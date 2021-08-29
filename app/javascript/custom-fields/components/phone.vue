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
      :value="obj.value && JSON.parse(obj.value).phone || ''"
      @input="setPhone($event)"
    />
    <input
      type="hidden"
      :name="getFieldName(index, 'value')" 
      :id="getFieldId(index)"
      :value="getPhone"
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
  },

  computed: {
    getPhone () {
      return this.obj.value
    }
  },

  methods: {
    setPhone(event) {
      if (!event || !event.target) return
      this.obj.value = JSON.stringify({ phone: event.target.value })
      this.$forceUpdate()
    }
  }
}
</script>