<template>
<fieldset class="form-group boolean required help_request_person">
  <div class="form-check">
    <input :name="getFieldName(index, 'value')" type="hidden" value="0" />
    <input 
      class="form-check-input boolean required" 
      type="checkbox" 
      value="1" 
      :checked="obj.value === '1'" 
      :name="getFieldName(index, 'value')"
      :id="getFieldId(index)" 
    />
    <label class="form-check-label boolean required" :for="getFieldId(index)">
      <span v-html="obj.name"> </span>
    </label>
  </div>
  <hidden-field :obj="obj" :index="index" />
</fieldset>
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