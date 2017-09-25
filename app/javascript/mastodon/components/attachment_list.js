import React from 'react';
import ImmutablePropTypes from 'react-immutable-proptypes';
import ImmutablePureComponent from 'react-immutable-pure-component';

const filename = url => url.split('/').pop().split('#')[0].split('?')[0];

export default class AttachmentList extends ImmutablePureComponent {

  static propTypes = {
    media: ImmutablePropTypes.list.isRequired,
  };

  render () {
    const { media } = this.props;

    return (
      <div className='attachment-list'>
        <div className='attachment-list__icon'>
          <i className='fa fa-link' />
        </div>

        <ul className='attachment-list__list'>
          {media.map(attachment =>
            <li key={attachment.get('id')}>
              <a href={attachment.get('remote_url')} target='_blank' rel='noopener'>{filename(attachment.get('remote_url'))}</a>
            </li>
          )}
        </ul>
      </div>
    );
  }

}
