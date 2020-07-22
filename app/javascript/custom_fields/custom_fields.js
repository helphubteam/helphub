export default class CustomFieldsPanel {
  constructor(el) {
    this.selectEl = el.querySelector('.js-help-request-kind-selector')
    this.container = el.querySelector('.js-custom-fields-container')
    this.url = el.dataset.url
    
    this.selectEl.addEventListener('change', this.updateCustomValues.bind(this));
    this.updateCustomValues();
  }

  updateCustomValues() {
    const helpRequestKindId = this.selectEl.value;
    fetch(this.url + '?help_request_kind_id=' + helpRequestKindId.toString()).
    then((response) => response.json()).
    then(this.renderData.bind(this))
  }

  renderData(data) {
    this.container.innerHTML = data.map((obj, index) => {
      return `<div class="form-group row string optional help_request_custom_values_value">
        <label
          class="col-sm-3 col-form-label string optional"
          :for="help_request_custom_values_attributes_${index}_value" 
        >
          ${obj.name}
        </label>
        <div class="col-sm-9">
          <input
            class="form-control string optional"
            type="text"
            name="help_request[custom_values_attributes][${index}][value]" 
            id="help_request_custom_values_attributes_${index}_value"
            value="${obj.value || ''}"
          />
        </div>
      </div>
      <input
        type="hidden"
        value="${obj.custom_field_id}"
        name="help_request[custom_values_attributes][${index}][custom_field_id]"
      />${ obj.id && `<input
        type="hidden"
        value="${obj.id}"
        name="help_request[custom_values_attributes][${index}][id]"
      />` || ''}`
    }).join('')
  }
}