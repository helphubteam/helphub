<template>
<div>
  <div v-for="(field, index) in customFields" :key="field.custom_field_id">
    <text-field v-if="field.data_type === 'string'" :obj="field" :index="index" />
    <text-area v-else-if="field.data_type === 'textarea'" :obj="field" :index="index" />
    <date-picker v-else-if="field.data_type === 'date'" :obj="field" :index="index" />
    <checkbox v-else-if="field.data_type === 'checkbox'" :obj="field" :index="index" />
  </div>
</div>
</template>

<script>
import Checkbox from "./components/checkbox"
import DatePicker from "./components/date-picker"
import TextArea from "./components/textarea"
import TextField from "./components/text-field"

export default {
  components: {
    Checkbox,
    DatePicker,
    TextArea,
    TextField
  },

  props: {
    requestPath: String,
  },

  data() {
    return {
      customFields: []
    }
  },

  async mounted() {
    window.vueEventBus.$on('helpRequestKindIdChanged', helpRequestKindId => {
      this.getCustomFields(helpRequestKindId);
    });
  },


  methods: {
    async getCustomFields(helpRequestKindId) {
      try {
        const response = await fetch(`${this.requestPath}?help_request_kind_id=${helpRequestKindId}`);
        this.customFields = await response.json();
      } catch(e) {
        console.error(e);
      } 
    }
  }
}
</script>