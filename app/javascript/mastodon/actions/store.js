import { Iterable, fromJS } from 'immutable';

export const STORE_HYDRATE = 'STORE_HYDRATE';
export const STORE_HYDRATE_LAZY = 'STORE_HYDRATE_LAZY';

const convertState = rawState =>
  fromJS(rawState, (k, v) =>
    Iterable.isIndexed(v) ? v.toList() : v.toMap());

export function hydrateStore(rawState) {
  const state = convertState(rawState);

  return {
    type: STORE_HYDRATE,
    state,
  };
};
