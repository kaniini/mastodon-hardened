import { delegate } from 'rails-ujs';

function handleDeleteStatus(event) {
  const [data] = event.detail;
  const element = document.querySelector(`[data-id="${data.id}"]`);
  if (element) {
    element.parentNode.removeChild(element);
  }
}

[].forEach.call(document.querySelectorAll('.trash-button'), (content) => {
  content.addEventListener('ajax:success', handleDeleteStatus);
});

const batchCheckboxClassName = '.batch-checkbox input[type="checkbox"]';

delegate(document, '#batch_checkbox_all', 'change', ({ target }) => {
  [].forEach.call(document.querySelectorAll(batchCheckboxClassName), (content) => {
    content.checked = target.checked;
  });
});

delegate(document, batchCheckboxClassName, 'change', () => {
  const checkAllElement = document.querySelector('#batch_checkbox_all');
  if (checkAllElement) {
    checkAllElement.checked = [].every.call(document.querySelectorAll(batchCheckboxClassName), (content) => content.checked);
  }
});

delegate(document, '.media-spoiler-show-button', 'click', () => {
  [].forEach.call(document.querySelectorAll('.activity-stream .media-spoiler-wrapper'), (content) => {
    content.classList.add('media-spoiler-wrapper__visible');
  });
});

delegate(document, '.media-spoiler-hide-button', 'click', () => {
  [].forEach.call(document.querySelectorAll('.activity-stream .media-spoiler-wrapper'), (content) => {
    content.classList.remove('media-spoiler-wrapper__visible');
  });
});
