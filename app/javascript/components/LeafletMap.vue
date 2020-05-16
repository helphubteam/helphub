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
      currentMarker: this.marker
    }
  },

  mounted() {
    const map = this.$refs.map.mapObject;

    let editableLayers = new L.FeatureGroup();
    map.addLayer(editableLayers);

    if (this.currentMarker) {
      editableLayers.addLayer(L.marker(this.currentMarker.coordinates));
      map.setView(this.currentMarker.coordinates, this.zoom);
    }

    const drawControl = new L.Control.Draw({
      position: 'topright',
      draw: {
        polyline: false,
        polygon: false,
        circlemarker: false,
        circle: false,
        rectangle: false,
      }
    });

    map.addControl(drawControl);
    map.on(L.Draw.Event.CREATED, e => this.replaceMarker(editableLayers, e.layer));
  },

  methods: {
    replaceMarker(layerGroup, markerLayer) {
      if (!this.currentMarker) {
        this.currentMarker = {
          type: 'Point'
        }
      };
      this.currentMarker.coordinates = Object.values(markerLayer.getLatLng());
      layerGroup.clearLayers();
      layerGroup.addLayer(markerLayer);
    }
  }
}
</script>
