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

    function renderText(obj, index) {
      return `<div class="form-group row help_request_custom_values_value">
        <label
          class="col-sm-3 col-form-label string optional"
          :for="help_request_custom_values_attributes_${index}_value" 
        >
          ${obj.name}
        </label>
        <div class="col-sm-9">
          <input id="x" type="hidden" value="${obj.value}" name="content">
          <trix-editor input="x"></trix-editor>
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
    }

    function renderString(obj, index) {
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
            value="${obj.value}"
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
    }

    function renderDate(obj, index) {
      return `<div class="form-group row string optional help_request_custom_values_value">
        <label
          class="col-sm-3 col-form-label string optional"
          :for="help_request_custom_values_attributes_${index}_value" 
        >
          ${obj.name}
        </label>
        <div class="col-sm-2">
          <input
            class="form-control string optional"
            type="date"
            name="help_request[custom_values_attributes][${index}][value]" 
            id="help_request_custom_values_attributes_${index}_value"
            value="${obj.value}"
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
    }

    function renderCheckbox(obj, index) {
      return `<div class="form-group row string optional help_request_custom_values_value">
        <label
          class="col-sm-3 col-form-label string optional"
          :for="help_request_custom_values_attributes_${index}_value" 
        >
          ${obj.name}
        </label>
        <div class="col-sm-1">
          <input
            class="form-control string optional"
            type="checkbox"
            name="help_request[custom_values_attributes][${index}][value]" 
            id="help_request_custom_values_attributes_${index}_value"
            value="${obj.value}"
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
    }

    this.container.innerHTML = data.map((obj, index) => {
      let contentArr = [];
      let dtype = obj.data_type;
      // const checkboxValue = obj.data_type;
      // let val = '';
      // if (checkboxValue === 'checkbox') {
      //   val = obj.value;
      // }
      // eslint-disable-next-line default-case
      switch (dtype) {
        case 'string':
          contentArr.push(renderString(obj, index));
          break;
        case 'textarea':
          contentArr.push(renderText(obj, index));
          break;
        case 'date':
          contentArr.push(renderDate(obj, index));
          break;
        case 'checkbox':
          contentArr.push(renderCheckbox(obj, index));
          break;
      }
    //   return `<div class="form-group row string optional help_request_custom_values_value">
    //     <label
    //       class="col-sm-3 col-form-label string optional"
    //       :for="help_request_custom_values_attributes_${index}_value"
    //     >
    //       ${obj.name}
    //     </label>
    //     <div class="col-sm-9">
    //       <input
    //         class="form-control string optional"
    //         type="${obj.data_type}"
    //         name="help_request[custom_values_attributes][${index}][value]"
    //         id="help_request_custom_values_attributes_${index}_value"
    //         value=val
    //         checked
    //       />
    //     </div>
    //   </div>
    //   <input
    //     type="hidden"
    //     value="${obj.custom_field_id}"
    //     name="help_request[custom_values_attributes][${index}][custom_field_id]"
    //   />${ obj.id && `<input
    //     type="hidden"
    //     value="${obj.id}"
    //     name="help_request[custom_values_attributes][${index}][id]"
    //   />` || ''}`
    // }).join('')
      return contentArr.join('')
  })
  }


}
