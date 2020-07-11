import CustomFieldsPanel from '../custom_fields/custom_fields'

document.addEventListener("DOMContentLoaded", () => {
  const el = window.document.getElementById('js-custom-fields')
  new CustomFieldsPanel(el)
});
