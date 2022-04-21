<template>
  <div style="height: 350px">
    <input 
      type="hidden" 
      :value="JSON.stringify(currentMarker)" 
      v-bind:class="[ isValid ? '' : 'is-invalid' ]" 
      :name="markerFieldName"
    />
    <div class="invalid-feedback">{{errorMessage}}</div>
    <l-map
      ref="map" 
      style="width: 100%"
      :zoom="zoom"
      :center="center"
    >
      <l-tile-layer :url="url" />
    </l-map>
    <select v-if="foundPoints.length > 1" class="browser-default custom-select" @change="onChangeCurrentPoint($event)">
      <option v-for="point in foundPoints" :key="point.label" :value="JSON.stringify(point)">
        {{point.label}}
      </option>
    </select>
  </div>
</template>

<script>
import { latLng, Icon } from "leaflet";
import 'leaflet-draw';
import { LMap, LTileLayer, LMarker } from 'vue2-leaflet';
import GeocoderFactory from '../map/geocoder-factory';

delete Icon.Default.prototype._getIconUrl;
Icon.Default.mergeOptions({
  iconRetinaUrl: require("leaflet/dist/images/marker-icon-2x.png"),
  iconUrl: require("leaflet/dist/images/marker-icon.png"),
  shadowUrl: require("leaflet/dist/images/marker-shadow.png")
});

export default {
  components: {
    LMap,
    LTileLayer,
    LMarker
  },

  props: {
    marker: Object,
    isValid: Boolean,
    addressChangedEventName: String,
    markerFieldName: String,
    errorMessage: String
  },

  data() {
    return {
      url: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      zoom: 16,
      center: [ 55.750979916446624, 37.628452777862556 ],
      currentMarker: this.marker,
      foundPoints: [],
      editableLayers: null,
      isManualMarker: false
    }
  },

  mounted() {
    const map = this.$refs.map.mapObject;

    this.editableLayers = new L.FeatureGroup();
    map.addLayer(this.editableLayers);

    if (this.currentMarker) {
      this.updateCurrentMarker(this.getCurrentMarkerLatLonOrderCoords()); 
      map.setView(this.getCurrentMarkerLatLonOrderCoords(), this.zoom);
    }

    map.addControl(this.getDrawControl());
    map.on(L.Draw.Event.CREATED, e => {
      this.updateCurrentMarker(Object.values(e.layer.getLatLng()));
      this.isManualMarker = true;
      window.vueEventBus.$emit(`${this.addressChangedEventName}_marker_changed`, this.currentMarker);
    });

    window.vueEventBus.$on(this.addressChangedEventName, searchString => {
      if (!this.isManualMarker) {
        const geocoder = GeocoderFactory.createGeocoder(GeocoderFactory.TYPES.yandex);
        geocoder.findByAddress(searchString).then(result => {
          if (result.length) {
            this.updateCurrentMarker([ result[0].lat, result[0].lon ]);
            this.$refs.map.mapObject.setView(this.getCurrentMarkerLatLonOrderCoords(), this.zoom);
            this.foundPoints = result;
            window.vueEventBus.$emit(`${this.addressChangedEventName}_marker_changed`, this.currentMarker);
          }
        });
      }
    });
  },

  methods: {
    /**
     * Updates current marker with new coorinates.
     * @param {[lat: number, lon: number]} coordinates Coordinates.
     */
    updateCurrentMarker([lat, lon]) {
      if (lat && lon) {
        // To store point correctly, we need to pass coordinates in [lng, lat] order.
        this.currentMarker = {
          type: 'Point',
          coordinates: [lon, lat]
        };

        // To show point correctly in the map, we need to pass coordinates in [lat, lng] order.
        this.editableLayers.clearLayers();
        this.editableLayers.addLayer(L.marker([lat, lon]));
      }
    },

    /**
     * Return control for map toolbar.
     */
    getDrawControl() {
      return new L.Control.Draw({
        position: 'topright',
        draw: {
          polyline: false,
          polygon: false,
          circlemarker: false,
          circle: false,
          rectangle: false,
        }
      })
    },

    /**
     * On change point event handler.
     */
    onChangeCurrentPoint(event) {
      const pointData = JSON.parse(event.target.value);
      this.updateCurrentMarker([ pointData.lat, pointData.lon ]);
      this.$refs.map.mapObject.setView(this.getCurrentMarkerLatLonOrderCoords(), this.zoom);
      window.vueEventBus.$emit(`${this.addressChangedEventName}_marker_changed`, this.currentMarker);
    },

    getCurrentMarkerLatLonOrderCoords() {
      return [this.currentMarker.coordinates[1], this.currentMarker.coordinates[0]];
    }
  }
}
</script>
