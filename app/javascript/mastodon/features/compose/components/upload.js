import React from 'react';
import ImmutablePropTypes from 'react-immutable-proptypes';
import PropTypes from 'prop-types';
import IconButton from '../../../components/icon_button';
import Motion from '../../ui/util/optional_motion';
import spring from 'react-motion/lib/spring';
import ImmutablePureComponent from 'react-immutable-pure-component';
import { defineMessages, injectIntl } from 'react-intl';
import classNames from 'classnames';

const messages = defineMessages({
  undo: { id: 'upload_form.undo', defaultMessage: 'Undo' },
  description: { id: 'upload_form.description', defaultMessage: 'Describe for the visually impaired' },
});

@injectIntl
export default class Upload extends ImmutablePureComponent {

  static propTypes = {
    media: ImmutablePropTypes.map.isRequired,
    intl: PropTypes.object.isRequired,
    onUndo: PropTypes.func.isRequired,
    onDescriptionChange: PropTypes.func.isRequired,
  };

  state = {
    hovered: false,
    focused: false,
    dirtyDescription: null,
  };

  handleUndoClick = () => {
    this.props.onUndo(this.props.media.get('id'));
  }

  handleInputChange = e => {
    this.setState({ dirtyDescription: e.target.value });
  }

  handleMouseEnter = () => {
    this.setState({ hovered: true });
  }

  handleMouseLeave = () => {
    this.setState({ hovered: false });
  }

  handleInputFocus = () => {
    this.setState({ focused: true });
  }

  handleInputBlur = () => {
    const { dirtyDescription } = this.state;

    this.setState({ focused: false, dirtyDescription: null });

    if (dirtyDescription !== null) {
      this.props.onDescriptionChange(this.props.media.get('id'), dirtyDescription);
    }
  }

  render () {
    const { intl, media } = this.props;
    const active          = this.state.hovered || this.state.focused;
    const description     = this.state.dirtyDescription || media.get('description') || '';

    return (
      <div className='compose-form__upload' onMouseEnter={this.handleMouseEnter} onMouseLeave={this.handleMouseLeave}>
        <Motion defaultStyle={{ scale: 0.8 }} style={{ scale: spring(1, { stiffness: 180, damping: 12 }) }}>
          {({ scale }) => (
            <div className='compose-form__upload-thumbnail' style={{ transform: `scale(${scale})`, backgroundImage: `url(${media.get('preview_url')})` }}>
              <IconButton icon='times' title={intl.formatMessage(messages.undo)} size={36} onClick={this.handleUndoClick} />

              <div className={classNames('compose-form__upload-description', { active })}>
                <label>
                  <span style={{ display: 'none' }}>{intl.formatMessage(messages.description)}</span>

                  <input
                    placeholder={intl.formatMessage(messages.description)}
                    type='text'
                    value={description}
                    maxLength={420}
                    onFocus={this.handleInputFocus}
                    onChange={this.handleInputChange}
                    onBlur={this.handleInputBlur}
                  />
                </label>
              </div>
            </div>
          )}
        </Motion>
      </div>
    );
  }

}
