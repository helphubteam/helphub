<template>
<div class="form-group row help_request_custom_values_value">
  <label
    class="col-sm-3 col-form-label string optional"
    :for="getFieldId(index)" 
  >
    {{obj.name}}
  </label>
  <div class="col-sm-9">
    <div class="row">
      <div class="col-sm-9">
        <input placeholder="Город" :value="this.escapeHtml(this.obj.value.city)}" class="form-control string required" type="text">
      </div>
      <div class="col-sm-9">
        <input placeholder="Район" :value="this.escapeHtml(this.obj.value.district)" class="form-control string optional" type="text">
      </div>
      <div class="col-sm-9">
        <input placeholder="Улица" :value="this.escapeHtml(this.obj.value.street)" class="form-control string required" type="text">
      </div>
      <div class="col-sm-9">
        <input placeholder="Дом" :value="this.escapeHtml(this.obj.value.house)" class="form-control string required" type="text">
      </div>
      <div class="col-sm-9">
        <input placeholder="Квартира" :value="this.escapeHtml(this.obj.value.apartment)" class="form-control string optional" type="text">
      </div>
    </div>
  </div>
  <hidden-field :obj="obj" :index="index" />
</div>
</template>

<script>
import fieldMixin from '../mixins/field-mixin'
import hiddenField from './hidden-field.vue'

export default {
  components: {
    hiddenField
  },

  mixins: [fieldMixin],

  props: {
    obj: Object,
    index: Number
  }
}
</script>