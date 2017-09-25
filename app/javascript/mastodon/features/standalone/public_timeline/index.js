import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import StatusListContainer from '../../ui/containers/status_list_container';
import {
  refreshPublicTimeline,
  expandPublicTimeline,
} from '../../../actions/timelines';
import Column from '../../../components/column';
import ColumnHeader from '../../../components/column_header';
import { defineMessages, injectIntl } from 'react-intl';

const messages = defineMessages({
  title: { id: 'standalone.public_title', defaultMessage: 'A look inside...' },
});

@connect()
@injectIntl
export default class PublicTimeline extends React.PureComponent {

  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    intl: PropTypes.object.isRequired,
  };

  handleHeaderClick = () => {
    this.column.scrollTop();
  }

  setRef = c => {
    this.column = c;
  }

  componentDidMount () {
    const { dispatch } = this.props;

    dispatch(refreshPublicTimeline());

    this.polling = setInterval(() => {
      dispatch(refreshPublicTimeline());
    }, 3000);
  }

  componentWillUnmount () {
    if (typeof this.polling !== 'undefined') {
      clearInterval(this.polling);
      this.polling = null;
    }
  }

  handleLoadMore = () => {
    this.props.dispatch(expandPublicTimeline());
  }

  render () {
    const { intl } = this.props;

    return (
      <Column ref={this.setRef}>
        <ColumnHeader
          icon='globe'
          title={intl.formatMessage(messages.title)}
          onClick={this.handleHeaderClick}
        />

        <StatusListContainer
          timelineId='public'
          loadMore={this.handleLoadMore}
          scrollKey='standalone_public_timeline'
          trackScroll={false}
        />
      </Column>
    );
  }

}
