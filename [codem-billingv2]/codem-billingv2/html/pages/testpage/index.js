import importTemplate from '../../js/util/importTemplate.js';
export default {
	template: await importTemplate('pages/testpage/index.html'),

	data: () => ({}),
	methods: {},

	computed: {
		...Vuex.mapState({}),
	},

	watch: {},

	components: {},
	beforeUnmount() {
		window.removeEventListener('keyup', this.keyHandler);
		window.removeEventListener('message', this.eventHandler);
	},

	mounted() {
		window.addEventListener('message', this.eventHandler);
		window.addEventListener('keyup', this.keyHandler);
	},
};
