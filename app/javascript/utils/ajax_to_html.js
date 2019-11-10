export default function ajaxToHtml(event) {
  const { detail: [,, xhr] } = event;

  return xhr.responseText;
}
