import React from 'react';
import PropTypes from 'prop-types';
import ImmutablePropTypes from 'react-immutable-proptypes';
import punycode from 'punycode';
import classnames from 'classnames';

const IDNA_PREFIX = 'xn--';

const decodeIDNA = domain => {
  return domain
    .split('.')
    .map(part => part.indexOf(IDNA_PREFIX) === 0 ? punycode.decode(part.slice(IDNA_PREFIX.length)) : part)
    .join('.');
};

const getHostname = url => {
  const parser = document.createElement('a');
  parser.href = url;
  return parser.hostname;
};

export default class Card extends React.PureComponent {

  static propTypes = {
    card: ImmutablePropTypes.map,
    maxDescription: PropTypes.number,
  };

  static defaultProps = {
    maxDescription: 50,
  };

  state = {
    width: 0,
  };

  renderLink () {
    const { card, maxDescription } = this.props;

    let image    = '';
    let provider = card.get('provider_name');

    if (card.get('image')) {
      image = (
        <div className='status-card__image'>
          <img src={card.get('image')} alt={card.get('title')} className='status-card__image-image' width={card.get('width')} height={card.get('height')} />
        </div>
      );
    }

    if (provider.length < 1) {
      provider = decodeIDNA(getHostname(card.get('url')));
    }

    const className = classnames('status-card', {
      'horizontal': card.get('width') > card.get('height'),
    });

    return (
      <a href={card.get('url')} className={className} target='_blank' rel='noopener'>
        {image}

        <div className='status-card__content'>
          <strong className='status-card__title' title={card.get('title')}>{card.get('title')}</strong>
          <p className='status-card__description'>{(card.get('description') || '').substring(0, maxDescription)}</p>
          <span className='status-card__host'>{provider}</span>
        </div>
      </a>
    );
  }

  renderPhoto () {
    const { card } = this.props;

    return (
      <a href={card.get('url')} className='status-card-photo' target='_blank' rel='noopener'>
        <img src={card.get('url')} alt={card.get('title')} width={card.get('width')} height={card.get('height')} />
      </a>
    );
  }

  setRef = c => {
    if (c) {
      this.setState({ width: c.offsetWidth });
    }
  }

  renderVideo () {
    const { card }  = this.props;
    const content   = { __html: card.get('html') };
    const { width } = this.state;
    const ratio     = card.get('width') / card.get('height');
    const height    = card.get('width') > card.get('height') ? (width / ratio) : (width * ratio);

    return (
      <div
        ref={this.setRef}
        className='status-card-video'
        dangerouslySetInnerHTML={content}
        style={{ height }}
      />
    );
  }

  render () {
    const { card } = this.props;

    if (card === null) {
      return null;
    }

    switch(card.get('type')) {
    case 'link':
      return this.renderLink();
    case 'photo':
      return this.renderPhoto();
    case 'video':
      return this.renderVideo();
    case 'rich':
    default:
      return null;
    }
  }

}
