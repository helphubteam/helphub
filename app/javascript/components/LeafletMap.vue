<template>
  <div style="height: 350px;">
    <input type='hidden' :value="JSON.stringify(currentMarker)" name='help_request[lonlat_geojson]' />
    <l-map
      ref="map" 
      style="width: 100%"
      :zoom="zoom"
      :center="center"
    >
      <l-tile-layer :url="url"/>
    </l-map>
  </div>
</template>

<script>
import { latLng } from "leaflet";
import 'leaflet-draw';
import { OpenStreetMapProvider } from 'leaflet-geosearch';
import { LMap, LTileLayer, LMarker } from 'vue2-leaflet';

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
      editableLayers: null,
      isManualMarker: false
    }
  },

  mounted() {
    const map = this.$refs.map.mapObject;

    this.editableLayers = new L.FeatureGroup();
    map.addLayer(this.editableLayers);

    this.updateCurrentMarker(this.currentMarker.coordinates); 
    if (this.currentMarker) {
      map.setView(this.currentMarker.coordinates, this.zoom);
    }

    map.addControl(this.getDrawControl());
    map.on(L.Draw.Event.CREATED, e => {
      this.updateCurrentMarker(Object.values(e.layer.getLatLng()));
      this.isManualMarker = true;
    });

    window.vueEventBus.$on('searchStringChanged', searchString => {
      if (!this.isManualMarker) {
        this.findByAddress(searchString).then(result => {
          if (result.length) {
            this.updateCurrentMarker([ result[0].y, result[0].x ]);
            this.$refs.map.mapObject.setView(this.currentMarker.coordinates, this.zoom);
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
      if (!this.currentMarker) {
        this.currentMarker = {
          type: 'Point'
        }
      };
      this.currentMarker.coordinates = coordinates;

      this.editableLayers.clearLayers();
      this.editableLayers.addLayer(L.marker(coordinates));
    },

    /**
     * Returns provider for searching by address.
     */
    getSearchProvider() {
      return new OpenStreetMapProvider();
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
     * Finds point by address.
     * @param {String} address Address to search.
     * @returns Promise
     */
    findByAddress(address) {
      return this.getSearchProvider().search({ query: address });
    }
  }
}
</script>
