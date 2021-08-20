<template>
<div>
  <input
      type="hidden"
      :value="obj.custom_field_id"
      :name="getFieldName(index, 'custom_field_id')"
    />
    <input 
      v-if="obj.id"
      type="hidden"
      :value="obj.id"
      :name="getFieldName(index, 'id')"
    />
</div>
</template>

<script>
import fieldMixin from '../mixins/field-mixin'

export default {
  mixins: [fieldMixin],

  props: {
    obj: Object,
    index: Number
  }
}
</script>