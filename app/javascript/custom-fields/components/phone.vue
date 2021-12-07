<template>
<div class="form-group row string optional help_request_custom_values_value">
  <label
    class="col-sm-3 col-form-label string optional"
    :for="getFieldId(index)" 
  >
  <span v-html="obj.name"> </span>
  </label>
  <div class="col-sm-9">
    <input
      class="form-control string optional"
      type="text"
      v-model="obj.value.phone"
    />
    <input
      type="hidden"
      :name="getFieldName(index, 'value')" 
      :id="getFieldId(index)"
      :value="phoneValue"
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

  data() {
    return {
      phoneValue: ''
    }
  },

  props: {
    obj: Object,
    index: Number
  },

  created() {
    this.obj.value = this.obj.value && JSON.parse(this.obj.value) || {};
    this.phoneValue = JSON.stringify(this.obj.value);
  },

  watch: {
    'obj.value': {
      handler() {
        this.phoneValue = JSON.stringify(this.obj.value);
      },
      deep: true
    }
  }
}
</script>