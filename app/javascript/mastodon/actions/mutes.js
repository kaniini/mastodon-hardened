import api, { getLinks } from '../api';
import { fetchRelationships } from './accounts';

export const MUTES_FETCH_REQUEST = 'MUTES_FETCH_REQUEST';
export const MUTES_FETCH_SUCCESS = 'MUTES_FETCH_SUCCESS';
export const MUTES_FETCH_FAIL    = 'MUTES_FETCH_FAIL';

export const MUTES_EXPAND_REQUEST = 'MUTES_EXPAND_REQUEST';
export const MUTES_EXPAND_SUCCESS = 'MUTES_EXPAND_SUCCESS';
export const MUTES_EXPAND_FAIL    = 'MUTES_EXPAND_FAIL';

export function fetchMutes() {
  return (dispatch, getState) => {
    dispatch(fetchMutesRequest());

    api(getState).get('/api/v1/mutes').then(response => {
      const next = getLinks(response).refs.find(link => link.rel === 'next');
      dispatch(fetchMutesSuccess(response.data, next ? next.uri : null));
      dispatch(fetchRelationships(response.data.map(item => item.id)));
    }).catch(error => dispatch(fetchMutesFail(error)));
  };
};

export function fetchMutesRequest() {
  return {
    type: MUTES_FETCH_REQUEST,
  };
};

export function fetchMutesSuccess(accounts, next) {
  return {
    type: MUTES_FETCH_SUCCESS,
    accounts,
    next,
  };
};

export function fetchMutesFail(error) {
  return {
    type: MUTES_FETCH_FAIL,
    error,
  };
};

export function expandMutes() {
  return (dispatch, getState) => {
    const url = getState().getIn(['user_lists', 'mutes', 'next']);

    if (url === null) {
      return;
    }

    dispatch(expandMutesRequest());

    api(getState).get(url).then(response => {
      const next = getLinks(response).refs.find(link => link.rel === 'next');
      dispatch(expandMutesSuccess(response.data, next ? next.uri : null));
      dispatch(fetchRelationships(response.data.map(item => item.id)));
    }).catch(error => dispatch(expandMutesFail(error)));
  };
};

export function expandMutesRequest() {
  return {
    type: MUTES_EXPAND_REQUEST,
  };
};

export function expandMutesSuccess(accounts, next) {
  return {
    type: MUTES_EXPAND_SUCCESS,
    accounts,
    next,
  };
};

export function expandMutesFail(error) {
  return {
    type: MUTES_EXPAND_FAIL,
    error,
  };
};
