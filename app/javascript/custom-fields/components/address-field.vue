<template>
<div class="form-group row help_request_custom_values_value">
  <h4 v-html="obj.name" />
  <div class="col-12">
    <div class="row">
      <div class="col-6">
        <div class="col-sm-9">
          <div class="form-group row">
            <input
              class="form-control string optional"
              placeholder="Город"
              type="text"
              :value="obj.value && JSON.parse(obj.value).city || ''"
              @input="setAddress('city', $event)"
            />
          </div>
        </div>
        <div class="col-sm-9">
          <div class="form-group row">
            <input
              class="form-control string optional"
              placeholder="Район"
              type="text"
              :value="obj.value && JSON.parse(obj.value).district || ''"
              @input="setAddress('district', $event)"
            />
          </div>
        </div>
        <div class="col-sm-9">
          <div class="form-group row">
            <input
              class="form-control string optional"
              placeholder="Улица"
              type="text"
              :value="obj.value && JSON.parse(obj.value).street || ''"
              @input="setAddress('street', $event)"
            />
          </div>
        </div>
        <div class="col-sm-9">
          <div class="form-group row">
            <input
              class="form-control string optional"
              placeholder="Дом"
              type="text"
              :value="obj.value && JSON.parse(obj.value).house || ''"
              @input="setAddress('house', $event)"
            />
          </div>
        </div>
        <div class="col-sm-9">
          <div class="form-group row">
            <input
              class="form-control string optional"
              placeholder="Квартира"
              type="text"
              :value="obj.value && JSON.parse(obj.value).apartment || ''"
              @input="setAddress('apartment', $event)"
            />
          </div>
        </div>
      </div>
      <div class="col-6">
        <leaflet-map :marker='null' :is-valid='true' error-message="" />
      </div>
    </div>
  </div>

  <input
    type="hidden"
    :name="getFieldName(index, 'value')" 
    :id="getFieldId(index)"
    :value="getAddress"
  />
  <hidden-field :obj="obj" :index="index" />
</div>
</template>

<script>
import fieldMixin from '../mixins/field-mixin'
import hiddenField from './hidden-field.vue'
import LeafletMap from '../../components/leaflet-map'

export default {
  components: {
    hiddenField,
    LeafletMap
  },

  mixins: [fieldMixin],

  props: {
    obj: Object,
    index: Number
  },

  computed: {
    getAddress () {
      return this.obj.value
    }
  },

  methods: {
    setAddress(field, event) {
      if (!event || !event.target) return
      let value = this.obj.value ? JSON.parse(this.obj.value) : {}
      value[field] = event.target.value
      this.obj.value = JSON.stringify(value)
      this.$forceUpdate()
    },
  }
}
</script>