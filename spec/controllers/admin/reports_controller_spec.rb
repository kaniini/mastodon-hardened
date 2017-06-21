require 'rails_helper'

describe Admin::ReportsController do
  render_views

  let(:user) { Fabricate(:user, admin: true) }
  before do
    sign_in user, scope: :user
  end

  describe 'GET #index' do
    it 'returns http success with no filters' do
      specified = Fabricate(:report, action_taken: false)
      Fabricate(:report, action_taken: true)

      get :index

      reports = assigns(:reports).to_a
      expect(reports.size).to eq 1
      expect(reports[0]).to eq specified
      expect(response).to have_http_status(:success)
    end

    it 'returns http success with resolved filter' do
      specified = Fabricate(:report, action_taken: true)
      Fabricate(:report, action_taken: false)

      get :index, params: { resolved: 1 }

      reports = assigns(:reports).to_a
      expect(reports.size).to eq 1
      expect(reports[0]).to eq specified

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'renders report' do
      report = Fabricate(:report)

      get :show, params: { id: report }

      expect(assigns(:report)).to eq report
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    describe 'with an unknown outcome' do
      it 'rejects the change' do
        report = Fabricate(:report)
        put :update, params: { id: report, outcome: 'unknown' }

        expect(response).to have_http_status(:missing)
      end
    end

    describe 'with an outcome of `resolve`' do
      it 'resolves the report' do
        report = Fabricate(:report)

        put :update, params: { id: report, outcome: 'resolve' }
        expect(response).to redirect_to(admin_report_path(report))
        report.reload
        expect(report.action_taken_by_account).to eq user.account
        expect(report.action_taken).to eq true
      end
    end

    describe 'with an outcome of `suspend`' do
      it 'suspends the reported account' do
        report = Fabricate(:report)
        allow(Admin::SuspensionWorker).to receive(:perform_async)

        put :update, params: { id: report, outcome: 'suspend' }
        expect(response).to redirect_to(admin_report_path(report))
        report.reload
        expect(report.action_taken_by_account).to eq user.account
        expect(report.action_taken).to eq true
        expect(Admin::SuspensionWorker).
          to have_received(:perform_async).with(report.target_account_id)
      end
    end

    describe 'with an outsome of `silence`' do
      it 'silences the reported account' do
        report = Fabricate(:report)

        put :update, params: { id: report, outcome: 'silence' }
        expect(response).to redirect_to(admin_report_path(report))
        report.reload
        expect(report.action_taken_by_account).to eq user.account
        expect(report.action_taken).to eq true
        expect(report.target_account).to be_silenced
      end
    end
  end
end
