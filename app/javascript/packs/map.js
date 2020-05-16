/* eslint-disable global-require */
/* eslint-disable no-new */
import Vue from 'vue/dist/vue.esm.js';
import LeafletMap from '../components/LeafletMap'

// Known issue with missing marker icons. See: https://vue2-leaflet.netlify.app/quickstart/#marker-icons-are-missing.
// eslint-disable-next-line
delete L.Icon.Default.prototype._getIconUrl;

// eslint-disable-next-line
L.Icon.Default.mergeOptions({  
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),  
  iconUrl: require('leaflet/dist/images/marker-icon.png'),  
  shadowUrl: require('leaflet/dist/images/marker-shadow.png')  
})

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#vue-app',
    components: {
      LeafletMap
    }
  });
});
