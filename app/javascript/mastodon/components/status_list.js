import React from 'react';
import ImmutablePropTypes from 'react-immutable-proptypes';
import { ScrollContainer } from 'react-router-scroll';
import PropTypes from 'prop-types';
import StatusContainer from '../containers/status_container';
import LoadMore from './load_more';
import ImmutablePureComponent from 'react-immutable-pure-component';
import IntersectionObserverWrapper from '../features/ui/util/intersection_observer_wrapper';
import { debounce } from 'lodash';

class StatusList extends ImmutablePureComponent {

  static propTypes = {
    scrollKey: PropTypes.string.isRequired,
    statusIds: ImmutablePropTypes.list.isRequired,
    onScrollToBottom: PropTypes.func,
    onScrollToTop: PropTypes.func,
    onScroll: PropTypes.func,
    trackScroll: PropTypes.bool,
    shouldUpdateScroll: PropTypes.func,
    isLoading: PropTypes.bool,
    hasMore: PropTypes.bool,
    prepend: PropTypes.node,
    emptyMessage: PropTypes.node,
  };

  static defaultProps = {
    trackScroll: true,
  };

  intersectionObserverWrapper = new IntersectionObserverWrapper();

  handleScroll = debounce((e) => {
    const { scrollTop, scrollHeight, clientHeight } = e.target;
    const offset = scrollHeight - scrollTop - clientHeight;
    this._oldScrollPosition = scrollHeight - scrollTop;

    if (250 > offset && this.props.onScrollToBottom && !this.props.isLoading) {
      this.props.onScrollToBottom();
    } else if (scrollTop < 100 && this.props.onScrollToTop) {
      this.props.onScrollToTop();
    } else if (this.props.onScroll) {
      this.props.onScroll();
    }
  }, 200, {
    trailing: true,
  });

  componentDidMount () {
    this.attachScrollListener();
    this.attachIntersectionObserver();
  }

  componentDidUpdate (prevProps) {
    // Reset the scroll position when a new toot comes in in order not to
    // jerk the scrollbar around if you're already scrolled down the page.
    if (prevProps.statusIds.size < this.props.statusIds.size &&
        prevProps.statusIds.first() !== this.props.statusIds.first() &&
        this._oldScrollPosition &&
        this.node.scrollTop > 0) {
      let newScrollTop = this.node.scrollHeight - this._oldScrollPosition;
      if (this.node.scrollTop !== newScrollTop) {
        this.node.scrollTop = newScrollTop;
      }
    }
  }

  componentWillUnmount () {
    this.detachScrollListener();
    this.detachIntersectionObserver();
  }

  attachIntersectionObserver () {
    this.intersectionObserverWrapper.connect({
      root: this.node,
      rootMargin: '300% 0px',
    });
  }

  detachIntersectionObserver () {
    this.intersectionObserverWrapper.disconnect();
  }

  attachScrollListener () {
    this.node.addEventListener('scroll', this.handleScroll);
  }

  detachScrollListener () {
    this.node.removeEventListener('scroll', this.handleScroll);
  }

  setRef = (c) => {
    this.node = c;
  }

  handleLoadMore = (e) => {
    e.preventDefault();
    this.props.onScrollToBottom();
  }

  render () {
    const { statusIds, onScrollToBottom, scrollKey, trackScroll, shouldUpdateScroll, isLoading, hasMore, prepend, emptyMessage } = this.props;

    let loadMore       = null;
    let scrollableArea = null;

    if (!isLoading && statusIds.size > 0 && hasMore) {
      loadMore = <LoadMore onClick={this.handleLoadMore} />;
    }

    if (isLoading || statusIds.size > 0 || !emptyMessage) {
      scrollableArea = (
        <div className='scrollable' ref={this.setRef}>
          <div className='status-list'>
            {prepend}

            {statusIds.map((statusId) => {
              return <StatusContainer key={statusId} id={statusId} intersectionObserverWrapper={this.intersectionObserverWrapper} />;
            })}

            {loadMore}
          </div>
        </div>
      );
    } else {
      scrollableArea = (
        <div className='empty-column-indicator' ref={this.setRef}>
          {emptyMessage}
        </div>
      );
    }

    if (trackScroll) {
      return (
        <ScrollContainer scrollKey={scrollKey} shouldUpdateScroll={shouldUpdateScroll}>
          {scrollableArea}
        </ScrollContainer>
      );
    } else {
      return scrollableArea;
    }
  }

}

export default StatusList;
