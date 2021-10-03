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
              v-model="obj.value.city"
            />
          </div>
        </div>
        <div class="col-sm-9">
          <div class="form-group row">
            <input
              class="form-control string optional"
              placeholder="Район"
              type="text"
              v-model="obj.value.district"
            />
          </div>
        </div>
        <div class="col-sm-9">
          <div class="form-group row">
            <input
              class="form-control string optional"
              placeholder="Улица"
              type="text"
              v-model="obj.value.street"
            />
          </div>
        </div>
        <div class="col-sm-9">
          <div class="form-group row">
            <input
              class="form-control string optional"
              placeholder="Дом"
              type="text"
              v-model="obj.value.house"
            />
          </div>
        </div>
        <div class="col-sm-9">
          <div class="form-group row">
            <input
              class="form-control string optional"
              placeholder="Квартира"
              type="text"
              v-model="obj.value.apartment"
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
    :value="addressValue"
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

  data() {
    return {
      apartment: '',
      addressValue: ''
    }
  },

  props: {
    obj: Object,
    index: Number
  },

  created() {
    this.obj.value = this.obj.value && JSON.parse(this.obj.value) || {};
    this.addressValue = JSON.stringify(this.obj.value);
  },

  watch: {
    'obj.value.city': function() {
      this.updateAddressValue();
    },

    'obj.value.district': function() {
      this.updateAddressValue();
    },

    'obj.value.street': function() {
      this.updateAddressValue();
    },

    'obj.value.house': function() {
      this.updateAddressValue();
    },

    'obj.value.apartment': function() {
      this.updateAddressValue();
    },
  },

  methods: {
    updateAddressValue() {
      this.addressValue = JSON.stringify(this.obj.value);
    }
  }
}
</script>