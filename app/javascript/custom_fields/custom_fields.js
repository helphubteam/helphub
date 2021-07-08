export default class CustomFieldsPanel {
  constructor(el) {
    this.selectEl = el.querySelector('.js-help-request-kind-selector')
    this.container = el.querySelector('.js-custom-fields-container')
    this.url = el.dataset.url
    
    this.selectEl.addEventListener('change', this.updateCustomValues.bind(this));
    const currentData = el.dataset.values
    
    if (currentData) {
      const parsedCurrentData = JSON.parse(currentData)
      if (parsedCurrentData) {
        this.renderData(parsedCurrentData);
        return
      }
    }
    this.updateCustomValues();
  }

  updateCustomValues() {
    const helpRequestKindId = this.selectEl.value;
    fetch(this.url + '?help_request_kind_id=' + helpRequestKindId.toString()).
    then((response) => response.json()).
    then(this.renderData.bind(this))
  }

  renderData(data) {

    function fieldName(index, key) {
      return `help_request[custom_values_attributes][${index}][${key}]`
    }

    function fieldId(index) {
      return `help_request_custom_values_attributes_${index}_value`
    }

    function renderHiddenFields(obj, index) {
      return `<input
        type="hidden"
        value="${obj.custom_field_id}"
        name="${fieldName(index, 'custom_field_id')}"
      />${ obj.id && `<input
        type="hidden"
        value="${obj.id}"
        name="${fieldName(index, 'id')}"
      />` || ''}`
    }

    function escapeHtml(unsafe) {
      return (unsafe || '')
           .replace(/&/g, "&amp;")
           .replace(/</g, "&lt;")
           .replace(/>/g, "&gt;")
           .replace(/"/g, "&quot;")
           .replace(/'/g, "&#039;");
    }

    function renderText(obj, index) {
      return `<div class="form-group row help_request_custom_values_value">
        <label
          class="col-sm-3 col-form-label string optional"
          for="${fieldId(index)}" 
        >
          ${obj.name}
        </label>
        <div class="col-sm-9">
          <input id="x" type="hidden" value="${escapeHtml(obj.value) || ''}" name="${fieldName(index, 'value')}">
          <trix-editor input="x"></trix-editor>
        </div>
        ${renderHiddenFields(obj, index)}
      </div>`
    }

    function renderString(obj, index) {
      return `<div class="form-group row string optional help_request_custom_values_value">
        <label
          class="col-sm-3 col-form-label string optional"
          for="${fieldId(index)}" 
        >
          ${obj.name}
        </label>
        <div class="col-sm-9">
          <input
            class="form-control string optional"
            type="text"
            name="${fieldName(index, 'value')}" 
            id="${fieldId(index)}"
            value="${obj.value || ''}"
          />
        </div>
        ${renderHiddenFields(obj, index)}
      </div>`
    }

    function renderDate(obj, index) {
      return `<div class="form-group row string optional help_request_custom_values_value">
        <label
          class="col-sm-3 col-form-label string optional"
          for="${fieldId(index)}" 
        >
          ${obj.name}
        </label>
        <div class="col-sm-3">
          <input
            class="form-control string optional"
            type="date"
            name="${fieldName(index, 'value')}" 
            id="${fieldId(index)}"
            value="${obj.value}"
          />
        </div>
        ${renderHiddenFields(obj, index)}
      </div>`
    }

    function renderCheckbox(obj, index) {
      return `
        <fieldset class="form-group boolean required help_request_person">
          <div class="form-check">
            <input name="${fieldName(index, 'value')}" type="hidden" value="0" />
            <input class="form-check-input boolean required" type="checkbox" value="1" ${obj.value == '1' && 'checked="checked"'} name="${fieldName(index, 'value')}" id="${fieldId(index)}" />
            <label class="form-check-label boolean required" for="${fieldId(index)}">
              ${obj.name}
            </label>
          </div>
          ${renderHiddenFields(obj, index)}
        </fieldset>
      `
    }

    function renderAddress(obj, index) {
      if (!obj.value) {
        obj.value = {
          city: '',
          apartment: '',
          district: '',
          house: '',
          street: ''
        }
      }
      const { city, apartment, district, house, street } = obj.value
      return `<div class="form-group row help_request_custom_values_value">
                <label
                  class="col-sm-3 col-form-label string optional"
                  for="${fieldId(index)}" 
                >
                  ${obj.name}
                </label>
              <div class="col-sm-9">
                <div class="row">
                  <div class="col-sm-9">
                    <input placeholder="Город" value="${escapeHtml(city)}" class="form-control string required" type="text" name="${fieldName(index, 'value')}[city]">
                  </div>
                  <div class="col-sm-9">
                    <input placeholder="Район" value="${escapeHtml(district)}" class="form-control string optional" type="text" name="${fieldName(index, 'value')}[district]" id="help_request_district">
                  </div>
                  <div class="col-sm-9">
                    <input placeholder="Улица" value="${escapeHtml(street)}" class="form-control string required" type="text" name="${fieldName(index, 'value')}[street]" id="help_request_street">
                  </div>
                  <div class="col-sm-9">
                    <input placeholder="Дом" value="${escapeHtml(house)}" class="form-control string required" type="text" name="${fieldName(index, 'value')}[house]" id="help_request_house">
                  </div>
                  <div class="col-sm-9">
                    <input placeholder="Квартира" value="${escapeHtml(apartment)}" class="form-control string optional" type="text" name="${fieldName(index, 'value')}[apartment]" id="help_request_apartment">
                  </div>
                </div>
              </div>
              ${renderHiddenFields(obj, index)}
            </div>`
    }

    this.container.innerHTML = data.map((obj, index) => {
      let dtype = obj.data_type;
      switch (dtype) {
        case 'string':
          return renderString(obj, index);
        case 'textarea':
          return renderText(obj, index);
        case 'date':
          return  renderDate(obj, index);
        case 'checkbox':
          return renderCheckbox(obj, index);
        case 'address':
          return renderAddress(obj, index);
      }
    }).join('')
  }


}
