<template>
  <div style="height: 350px;">
    <input type='hidden' :value="JSON.stringify(currentMarker)" name='help_request[lonlat_geojson]' />
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
import { latLng } from "leaflet";
import 'leaflet-draw';
import { LMap, LTileLayer, LMarker } from 'vue2-leaflet';
import GeocoderFactory from '../map/geocoder-factory';

export default {
  components: {
    LMap,
    LTileLayer,
    LMarker
  },

  props: ['marker'],

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
      this.updateCurrentMarker(this.currentMarker.coordinates); 
      map.setView(this.currentMarker.coordinates, this.zoom);
    }

    map.addControl(this.getDrawControl());
    map.on(L.Draw.Event.CREATED, e => {
      this.updateCurrentMarker(Object.values(e.layer.getLatLng()));
      this.isManualMarker = true;
    });

    window.vueEventBus.$on('searchStringChanged', searchString => {
      if (!this.isManualMarker) {
        const geocoder = GeocoderFactory.createGeocoder(GeocoderFactory.TYPES.openStreetMap);
        geocoder.findByAddress(searchString).then(result => {
          if (result.length) {
            this.updateCurrentMarker([ result[0].lon, result[0].lat ]);
            this.$refs.map.mapObject.setView(this.currentMarker.coordinates, this.zoom);
            this.foundPoints = result;
          }
        });
      }
    });
  },

  methods: {
    /**
     * Updates current marker with new coorinates.
     * @param {Array} coordinates Coordinates.
     */
    updateCurrentMarker(coordinates) {
      if (coordinates) {
        if (!this.currentMarker) {
          this.currentMarker = {
            type: 'Point'
          }
        };
        this.currentMarker.coordinates = coordinates;

        this.editableLayers.clearLayers();
        this.editableLayers.addLayer(L.marker(coordinates));
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
      this.updateCurrentMarker([ pointData.lon, pointData.lat ]);
      this.$refs.map.mapObject.setView(this.currentMarker.coordinates, this.zoom);
    }
  }
}
</script>
