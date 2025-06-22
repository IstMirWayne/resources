var resourceName = 'codem-billing';

if (window.GetParentResourceName) {
	resourceName = window.GetParentResourceName();
}

window.postNUI = async (name, data) => {
	try {
		const response = await fetch(`https://${resourceName}/${name}`, {
			method: 'POST',
			mode: 'cors',
			cache: 'no-cache',
			credentials: 'same-origin',
			headers: {
				'Content-Type': 'application/json',
			},
			redirect: 'follow',
			referrerPolicy: 'no-referrer',
			body: JSON.stringify(data),
		});
		return !response.ok ? null : response.json();
	} catch (error) {}
};

import testpage from '../pages/testpage/index.js';
import personelpage from '../pages/personelpage/index.js';
import businesspage from '../pages/businesspage/index.js';
import adminpage from '../pages/adminpage/index.js';
import { GameView } from './gameView.js';
import { NotificationManager } from './notifications.js';
import { EventHandlerManager } from './eventHandlers/index.js';

const store = Vuex.createStore({
	components: {
		testpage: testpage,
		personelpage: personelpage,
		businesspage: businesspage,
		adminpage: adminpage,
	},
	state: {
		activePage: 'personelpage',
		currencyUnit: '$',
		showNavbar: true,
		TabletNotifications: [],
		NormalNotifications: [],
		AdminData: {},
		CreateBillModal: false,
		PlayerData: {
			profilephoto: 'https://r2.fivemanage.com/p0WfhJFBqn6SlWAIJkdTx/def.png',
			name: 'test',
			bank: 'asd',
		},
		BillingTax: 0.18,
		OverDueDate: 4,
		ApplicationsData: {},
		UpdateSpend: false,
		JobsData: false,
		UpdateJobSpend: false,
		ServerTaxes: {},
		UpdateTaxes: false,
		UpdateAdminSpend: false,
		Locales: [],
	},
	getters: {},
	mutations: {},
	actions: {
		SetShowNavbar({ state }, value) {
			state.showNavbar = value;
		},
		SetCreateBillingModal({ state }, value) {
			state.CreateBillModal = value;
		},
		SetActivePage({ state }, value) {
			state.activePage = value;
		},

		TabletNotification({ state }, notificationData) {
			notificationManager.showTabletNotification({
				message: notificationData.message,
				timeout: notificationData.timeout || 5000,
				header: notificationData.header || 'Notification',
				type: notificationData.type || 'info',
			});
		},

		NormalNotification({ state }, notificationData) {
			notificationManager.showNormalNotification({
				message: notificationData.message,
				timeout: notificationData.timeout || 5000,
				header: notificationData.header || 'Notification',
				type: notificationData.type || 'info',
			});
		},
	},
});

let eventHandler;

const app = Vue.createApp({
	components: {
		testpage: testpage,
		personelpage: personelpage,
		businesspage: businesspage,
		adminpage: adminpage,
	},
	data: () => ({
		width: window.innerWidth,
		height: window.innerHeight,
		ApprovalMenu: false,
		OpenBillingMenu: false,
		gameView: {},
		ApprovalMenuData: {
			page: 'page1',
			businesslogo: '',
		},
		ApplyForBillingPlayer: false,
		tooltip: {
			visible: false,
			text: '',
			x: 0,
			y: 0,
			index: null,
		},

		NewBilling: false,
		ShowBillingModal: false,
		waitingForJobData: false,
		PaidedBilling: false,
	}),
	methods: {
		PayBills(value) {
			postNUI('PayBills', value);
		},
		PayLaterButton() {
			postNUI('PayLaterButton');
			this.NewBilling = false;
			this.ShowBillingModal = false;
		},
		ShowTooltip(event, data, index) {
			this.tooltip.visible = true;
			this.tooltip.text = data;
			this.tooltip.x = event.clientX + 10;
			this.tooltip.y = event.clientY + 10;
			this.tooltip.index = index;
		},
		HideTooltip() {
			this.tooltip.visible = false;
		},
		ApplyForBilling() {
			postNUI('ApplyForBilling');
		},
		SendApprovalJob() {
			if (this.ApprovalMenuData.businesslogo.length <= 0) {
				postNUI('SendApprovalJob', {
					businesslogo: false,
				});
				return;
			}
			if (this.ApprovalMenuData.businesslogo.length > 400) {
				this.$store.dispatch('TabletNotification', {
					message: this.Locales['linktoolong'],
					type: 'error',
				});
				return;
			}

			const image = new Image();
			image.onload = () => {
				postNUI('SendApprovalJob', {
					businesslogo: this.ApprovalMenuData.businesslogo,
				});
			};
			image.onerror = () => {
				this.$store.dispatch('TabletNotification', {
					message: this.Locales['invalidimageurl'],
					type: 'error',
				});
			};

			image.src = this.ApprovalMenuData.businesslogo;
		},
		ChangeApprovalMenuPage(page) {
			this.ApprovalMenuData.page = page;
		},
		CloseApprovalMenu() {
			this.ApprovalMenu = false;
			postNUI('CloseApprovalMenu');
			if (this.gameView) {
				this.gameView.stop();
				this.gameView.destroy();
				this.gameView = null;
				const sourceCanvas = document.querySelector('#backgroundCanvas');
				if (sourceCanvas) {
					sourceCanvas.style.display = 'none';
				}
			}
		},
		CreateBill() {
			if (this.$store.state.activePage === 'personelpage') {
				if (this.$store.state.PlayerData.createbilling == 'true') {
					this.$store.state.CreateBillModal = true;
				} else {
					this.$store.dispatch('TabletNotification', {
						message: this.Locales['notapproved'],
						type: 'info',
					});
				}
			}

			if (this.$store.state.activePage === 'businesspage') {
				if (this.$store.state.JobsData && this.$store.state.JobsData.personels && this.$store.state.JobsData.personels[this.$store.state.PlayerData.identifier]) {
					let PersonelData = this.$store.state.JobsData.personels[this.$store.state.PlayerData.identifier];
					if (PersonelData.permission.billplayers) {
						this.$store.state.CreateBillModal = true;
					} else {
						this.$store.dispatch('TabletNotification', {
							message: this.Locales['notapproved'],
							type: 'info',
						});
					}
				}
			}
		},
		ChangeCurrentPage(value) {
			if (value == 'businesspage') {
				if (!this.$store.state.JobsData) {
					this.$store.dispatch('TabletNotification', {
						message: this.Locales['notbusinessowner'],
						type: 'info',
					});
					return;
				}
			}
			this.$store.state.activePage = value;
		},
		GetTimeAndDate() {
			const now = new Date();
			const options = {
				month: 'short',
				day: '2-digit',
				hour: '2-digit',
				minute: '2-digit',
			};

			const formattedDate = now.toLocaleString('en-US', options);

			return formattedDate;
		},
		CloseBillingMenu() {
			if (this.OpenBillingMenu) {
				this.OpenBillingMenu = false;
				postNUI('CloseBillingMenu');
				if (this.gameView) {
					this.gameView.stop();
					this.gameView.destroy();
					this.gameView = null;
					const sourceCanvas = document.querySelector('#backgroundCanvas');
					if (sourceCanvas) {
						sourceCanvas.style.display = 'none';
					}
				}
			}
		},

		keyHandler(event) {
			if (event.key === 'Escape') {
				this.CloseBillingMenu();
				if (this.ApprovalMenu) {
					this.CloseApprovalMenu();
				}
			}
		},

		eventHandler(event) {
			eventHandler.handleEvent(event);
		},

		createGameView(canvas) {
			try {
				if (!canvas || !(canvas instanceof HTMLCanvasElement)) {
					console.error('Not a valid <canvas> element.');
					return;
				}
				this.gameView = new GameView(canvas);
			} catch (error) {
				console.error('GameView creation failed:', error);
			}
		},
	},
	computed: {
		...Vuex.mapState({
			activePage: (state) => state.activePage,
			currencyUnit: (state) => state.currencyUnit,
			CreateBillModal: (state) => state.CreateBillModal,
			PlayerData: (state) => state.PlayerData,
			Locales: (state) => state.Locales,
			BillingTax: (state) => state.BillingTax,
		}),
	},
	mounted() {
		eventHandler = new EventHandlerManager(store, this);
		window.addEventListener('message', this.eventHandler);
		window.addEventListener('keyup', this.keyHandler);
		document.querySelector('#app').style.display = 'block';
	},
	beforeDestroy() {
		window.removeEventListener('message', this.eventHandler);
		window.removeEventListener('keyup', this.keyHandler);
	},
	watch: {},
});

const notificationManager = new NotificationManager();
notificationManager.setStore(store);

app.config.globalProperties.$notificationManager = notificationManager;

app.use(store);
app.mount('#app');
