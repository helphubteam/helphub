<template>
<div class="form-group row string optional help_request_custom_values_value">
  <label
    class="col-sm-3 col-form-label string optional"
    :for="getFieldId(index)" 
  >
    <span v-html="obj.name"> </span>
  </label>
  <div class="col-sm-3">
    <input
      class="form-control string optional"
      type="date"
      :name="getFieldName(index, 'value')" 
      :id="getFieldId(index)"
      :value="obj.value"
    />
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