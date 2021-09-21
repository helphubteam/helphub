<template>
<div class="form-group row help_request_custom_values_value">
  <label
    class="col-sm-3 col-form-label string optional"
    :for="getFieldId(index)" 
  >
    <span v-html="obj.name"> </span>
  </label>
  <div class="col-sm-9">
    <textarea id="x" style="display:none" v-html="this.escapeHtml(this.obj.value) || ''" :name="getFieldName(index, 'value')"></textarea>
    <trix-editor input="x"></trix-editor>
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