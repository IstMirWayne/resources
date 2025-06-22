import importTemplate from '../../js/util/importTemplate.js';
import { getChartConfig } from './chartConfig.js';

export default {
	template: await importTemplate('pages/personelpage/index.html'),

	data: () => ({
		category: [
			{
				name: 'dashboard',
			},
			{
				name: 'unpaidbills',
			},
			{
				name: 'paidbills',
			},
			{
				name: 'awatingpayments',
			},
			{
				name: 'taxes',
			},
		],
		currentPage: 'dashboard',
		ActiveModal: '',
		CreateBillingPage: '',
		ShowLoadingBar: true,
		NearbySwiperValue: null,
		Models: {
			CreateBillingPlayerID: '',
			BillingReason: '',
			BillingAmount: '',
			UnpaidBills: '',
			AwaitingPayments: '',
			PaidBills: '',
			InvoiceID: '',
			OnOverDue: '',
			TaxesBills: '',
		},
		NearbyPlayers: [],
		CreateBillingData: {
			reasons: [],
			targetplayerdata: [],
		},
		tooltip: {
			visible: false,
			text: '',
			x: 0,
			y: 0,
			index: null,
		},
		PayAllBills: [],
		PayWithBilling: '',
		PersonelPageChart: null,
		OpenPersonelPage: false,
		OpacityValue: -1,
		ShowChartLoadingBar: true,
		CancelBillingID: false,
	}),
	methods: {
		GetTaxesAllTotal(value) {
			const subtotal = value;
			if (subtotal === 0) return 0;

			const total = subtotal * (1 + this.BillingTax);
			return total % 1 >= 0.5 ? Math.ceil(total) : Math.floor(total);
		},
		ChangeOpacity(value) {
			this.OpacityValue = value;
		},
		PayAllBilling() {
			postNUI('PayAllBills');
			this.CloseActiveModal();
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
		OpenAdminPage() {
			this.$store.dispatch('SetActivePage', 'adminpage');
			this.$store.dispatch('SetShowNavbar', false);
		},
		CancelAwaitingBill(invoiceid) {
			this.CancelBillingID = invoiceid;
		},
		CancelBilling() {
			if (!this.CancelBillingID) return;
			postNUI('CancelAwaitingBill', this.CancelBillingID);
		},
		async GetBillingInvoiceID() {
			this.PayWithBilling = '';
			if (this.Models.InvoiceID.length > 0) {
				let result = await postNUI('GetBillingInvoiceID', this.Models.InvoiceID);
				if (result) {
					this.PayWithBilling = result;
					this.ActiveModal = 'paywithinvoiceid2';
				}
			}
		},
		PayBills(value) {
			postNUI('PayBills', value);
			this.CloseActiveModal();
		},
		GetFormattedData() {
			const today = new Date();

			const day = today.getDate().toString().padStart(2, '0');
			const month = (today.getMonth() + 1).toString().padStart(2, '0');
			const year = today.getFullYear();

			return `${day}.${month}.${year}`;
		},

		GetDataAfterDays() {
			let days = this.OverDueDate;
			const today = new Date();
			today.setDate(today.getDate() + days);

			const day = today.getDate().toString().padStart(2, '0');
			const month = (today.getMonth() + 1).toString().padStart(2, '0');
			const year = today.getFullYear();

			return `${day}.${month}.${year}`;
		},

		GetFirstName(fullName) {
			if (!fullName) return '';
			return fullName.split(' ')[0];
		},
		GetLastName(fullName) {
			if (!fullName) return '';
			const parts = fullName.split(' ');
			return parts.length > 1 ? parts[parts.length - 1] : '';
		},

		RemoveBillingReason(id) {
			this.CreateBillingData.reasons = this.CreateBillingData.reasons.filter((reason) => reason.id !== id);
		},
		AddBillingReason() {
			if (this.Models.BillingReason.length > 0 && this.Models.BillingAmount.length > 0) {
				this.CreateBillingData.reasons.push({
					reason: this.Models.BillingReason,
					amount: this.Models.BillingAmount,
					id: this.CreateBillingData.reasons.length + 1,
				});
				this.Models.BillingReason = '';
				this.Models.BillingAmount = '';
			}
		},
		checkInput() {
			if (this.Models.CreateBillingPlayerID.length > 0) {
				this.Models.CreateBillingPlayerID = this.Models.CreateBillingPlayerID.replace(/[^0-9]/g, '');
			}
			if (this.Models.BillingAmount.length > 0) {
				this.Models.BillingAmount = this.Models.BillingAmount.replace(/[^0-9]/g, '');
			}
		},
		NearbySwiper() {
			this.NearbySwiperValue = new Swiper('#nearbyplayers', {
				slidesPerView: 4,
				loop: false,
				slidesPerGroup: 1,
				spaceBetween: 10,

				navigation: {
					nextEl: '.nextbutton',
					prevEl: '.prevbutton',
				},
			});
		},
		SelectBillingPlayer(value) {
			if (!this.NearbyPlayers || !this.NearbyPlayers.Players || this.NearbyPlayers.Players.length == 0) {
				this.$store.dispatch('TabletNotification', {
					message: this.Locales['nearbyplayersnotfound'],
					type: 'error',
				});
				return;
			}

			let findPlayer = this.NearbyPlayers.Players.find((player) => player.id == value);

			if (findPlayer) {
				this.CreateBillingData.targetplayerdata = findPlayer;
				this.CreateBillingPage = 'createbill2';
			} else {
				this.$store.dispatch('TabletNotification', {
					message: this.Locales['nearbyplayersnotfound'],
					type: 'error',
				});
				return;
			}
		},
		ChangeCreateBillingPage(value) {
			if (this.ShowLoadingBar) {
				this.$store.dispatch('TabletNotification', {
					message: this.Locales['pleasewait'],
					type: 'info',
				});
				return;
			}
			if (this.CreateBillingPage == 'createbill2') {
				if (this.CreateBillingData.reasons.length == 0) {
					this.$store.dispatch('TabletNotification', {
						message: this.Locales['plsentertodetails'],
						type: 'info',
					});
					return;
				}

				postNUI('CreateBillingPersonel', this.CreateBillingData);
				this.CreateBillingPage = '';
				this.CloseActiveModal();
				return;
			}

			if (this.CreateBillingPage == 'createbill1') {
				if (this.Models.CreateBillingPlayerID.length == 0) {
					this.$store.dispatch('TabletNotification', {
						message: this.Locales['selectplayerorid'],
						type: 'info',
					});
					return;
				} else {
					if (!this.NearbyPlayers || !this.NearbyPlayers.Players || this.NearbyPlayers.Players.length == 0) {
						this.$store.dispatch('TabletNotification', {
							message: this.Locales['nearbyplayersnotfound'],
							type: 'error',
						});
						return;
					}

					let findPlayer = this.NearbyPlayers.Players.find((player) => player.id == this.Models.CreateBillingPlayerID);
					if (findPlayer) {
						this.CreateBillingData.targetplayerdata = findPlayer;
						this.CreateBillingPage = value;
					} else {
						this.$store.dispatch('TabletNotification', {
							message: this.Locales['nearbyplayersnotfound'],
							type: 'error',
						});
						return;
					}
				}
			}
		},
		ChangePage(value) {
			this.currentPage = value;
		},
		CloseActiveModal() {
			this.ActiveModal = '';
			this.Models.CreateBillingPlayerID = '';
			this.Models.BillingReason = '';
			this.Models.BillingAmount = '';
			this.Models.UnpaidBills = '';
			this.Models.AwaitingPayments = '';
			this.Models.PaidBills = '';
			this.Models.InvoiceID = '';

			this.$store.dispatch('SetShowNavbar', true);
		},
		updatePayAllBills(bills) {
			this.PayAllBills = bills.map((item) => ({
				name: item.identifiername,
				amount: parseFloat(item.amount) || 0,
			}));
		},
		ChangeActiveModel(value) {
			this.$store.dispatch('SetShowNavbar', false);

			if (value === 'payall') {
				const bills = this.currentPage === 'unpaidbills' ? this.GetUnpaidBills : this.GetOnOverDueBills;

				if (!bills.length) {
					this.$store.dispatch('TabletNotification', {
						message: this.Locales['noawaitingbill'],
						type: 'info',
					});
					this.$store.dispatch('SetShowNavbar', true);
					return;
				}

				this.updatePayAllBills(bills);
			}

			this.ActiveModal = value;
		},
		async GetNearbyPlayers() {
			this.ShowLoadingBar = true;
			this.NearbyPlayers = [];
			let result = await postNUI('GetNearbyPlayers');

			if (result.Players.length > 0) {
				this.NearbyPlayers = result;
				setTimeout(() => {
					this.NearbySwiper();
				}, 250);
			} else {
				this.NearbyPlayers = [];
			}
			this.ShowLoadingBar = false;
		},
		prepareChartData() {
			return {
				incoming: [
					this.PlayerData.spenddata.incoming.mon || 0,
					this.PlayerData.spenddata.incoming.tue || 0,
					this.PlayerData.spenddata.incoming.wed || 0,
					this.PlayerData.spenddata.incoming.thu || 0,
					this.PlayerData.spenddata.incoming.fri || 0,
					this.PlayerData.spenddata.incoming.sat || 0,
					this.PlayerData.spenddata.incoming.sun || 0,
				],
				outgoing: [
					this.PlayerData.spenddata.outgoing.mon || 0,
					this.PlayerData.spenddata.outgoing.tue || 0,
					this.PlayerData.spenddata.outgoing.wed || 0,
					this.PlayerData.spenddata.outgoing.thu || 0,
					this.PlayerData.spenddata.outgoing.fri || 0,
					this.PlayerData.spenddata.outgoing.sat || 0,
					this.PlayerData.spenddata.outgoing.sun || 0,
				],
			};
		},

		initializeChart(ctx, data) {
			Chart.defaults.color = '#646365';
			Chart.defaults.fontFamily = 'gilroybold';

			let chartLocales = [
				this.Locales['monday'],
				this.Locales['tuesday'],
				this.Locales['wednesday'],
				this.Locales['thursday'],
				this.Locales['friday'],
				this.Locales['saturday'],
				this.Locales['sunday'],
			];

			this.PersonelPageChart = new Chart(ctx, getChartConfig(data, chartLocales));
		},

		async CreateChartPersonel() {
			if (this.currentPage !== 'dashboard' || !this.OpenPersonelPage) return;
			this.ShowChartLoadingBar = true;
			if (this.PersonelPageChart) {
				this.PersonelPageChart.destroy();
			}

			try {
				const ctx = document.getElementById('personelPageChart');
				if (!ctx || !ctx.offsetWidth || !ctx.offsetHeight) {
					console.log('Canvar not found. Again trying...');
					setTimeout(() => this.CreateChartPersonel(), 100);
					return;
				}

				const chartData = this.prepareChartData();

				setTimeout(() => {
					if (!this.OpenPersonelPage) return;
					this.initializeChart(ctx, chartData);
					this.ShowChartLoadingBar = false;
				}, 750);
			} catch (error) {
				console.log('Chart creation error:', error);
				this.ShowChartLoadingBar = false;
			}
		},

		validateBillingData() {
			return this.PlayerData && this.PlayerData.billing && Object.values(this.PlayerData.billing).length > 0;
		},

		filterBillingsBySearch(item, searchValue) {
			// Arama değeri boşsa tüm öğeleri göster
			if (!searchValue || searchValue.trim() === '') return true;

			// Arama yapılacak alanları kontrol et
			const searchableFields = [
				// Temel alanlar
				item.targetname?.toLowerCase(),
				item.invoiceid?.toLowerCase(),
				item.identifiername?.toLowerCase(),
				item.formatdate?.toLowerCase(),
				item.formatoverduedate?.toLowerCase(),

				// Tutarlar (string olarak)
				item.amount?.toString(),
				item.totalAmount?.toString(),

				// Fatura tipi
				item.billtype?.toLowerCase(),
				item.identifier?.toLowerCase(),
			];

			// Reason array'indeki değerleri de ekle
			if (item.reason && Array.isArray(item.reason)) {
				item.reason.forEach((r) => {
					searchableFields.push(r.reason?.toLowerCase());
					searchableFields.push(r.amount?.toString());
				});
			}

			// Herhangi bir alanda eşleşme var mı kontrol et
			return searchableFields.some((field) => field && field.includes(searchValue));
		},

		resetBillingForm() {
			this.ActiveModal = '';
			this.CreateBillingPage = '';
			this.Models.CreateBillingPlayerID = '';
			this.Models.BillingReason = '';
			this.Models.BillingAmount = '';
			this.NearbyPlayers = [];
			this.CreateBillingData = {
				reasons: [],
				targetplayerdata: [],
			};
		},

		initializeCreateBill() {
			this.ActiveModal = 'createbill';
			this.CreateBillingPage = 'createbill1';
			this.$store.dispatch('SetShowNavbar', false);
			this.$store.dispatch('SetCreateBillingModal', false);
			this.GetNearbyPlayers();
		},
	},

	computed: {
		...Vuex.mapState({
			currencyUnit: (state) => state.currencyUnit,
			CreateBillModal: (state) => state.CreateBillModal,
			PlayerData: (state) => state.PlayerData,
			BillingTax: (state) => state.BillingTax,
			OverDueDate: (state) => state.OverDueDate,
			activePage: (state) => state.activePage,
			UpdateSpend: (state) => state.UpdateSpend,
			Locales: (state) => state.Locales,
			ServerTaxes: (state) => state.ServerTaxes,
		}),
		GetPersonelServerTaxes() {
			return Object.values(this.ServerTaxes).filter((item) => item.type == 'citizen');
		},
		billingSummary() {
			if (!this.validateBillingData()) {
				return {
					unpaidCount: 0,
					paidCount: 0,
					totalAmount: 0,
				};
			}

			return Object.values(this.PlayerData.billing).reduce(
				(summary, item) => {
					if (item.targetidentifier === this.PlayerData.identifier) {
						if (item.status === 'unpaid') summary.unpaidCount++;
						if (item.status === 'paid') summary.paidCount++;
						summary.totalAmount += parseFloat(item.amount || 0);
					}
					return summary;
				},
				{ unpaidCount: 0, paidCount: 0, totalAmount: 0 }
			);
		},
		GetPaidAndUnpaidBillsTotalLength() {
			return this.billingSummary.paidCount + this.billingSummary.unpaidCount;
		},
		GetSubtotalCreateBillingAmount() {
			return this.CreateBillingData.reasons.reduce((acc, item) => acc + (parseInt(item.amount) || 0), 0);
		},
		GetSubtotalCreateBillingAmountWithTax() {
			const subtotal = this.GetSubtotalCreateBillingAmount;
			if (subtotal === 0) return 0;

			const total = subtotal * (1 + this.BillingTax);
			return total % 1 >= 0.5 ? Math.ceil(total) : Math.floor(total);
		},
		GetAllTotalPayAll() {
			if (this.PayAllBills.length > 0) {
				const subtotal = this.PayAllBills.reduce((acc, item) => acc + parseFloat(item.amount || 0), 0);
				const taxAmount = subtotal * this.BillingTax;
				const total = subtotal + taxAmount;
				if (total % 1 >= 0.5) {
					return Math.ceil(total);
				} else {
					return Math.floor(total);
				}
			} else {
				return 0;
			}
		},

		GetUnpaidBills() {
			if (!this.validateBillingData()) return [];

			const searchValue = this.Models.UnpaidBills.toLowerCase().trim();

			return Object.values(this.PlayerData.billing)
				.filter((item) => {
					const baseFilter = item.status === 'unpaid' && item.identifier !== 'systemtax' && item.overduestatus === 'false' && item.targetidentifier === this.PlayerData.identifier;
					if (!baseFilter) return false;
					const matchesSearch = this.filterBillingsBySearch(item, searchValue);
					return matchesSearch;
				})
				.sort((a, b) => {
					return parseInt(b.date) - parseInt(a.date);
				});
		},

		GetTaxesBill() {
			if (!this.validateBillingData()) return [];

			const searchValue = this.Models.TaxesBills.toLowerCase();
			return Object.values(this.PlayerData.billing).filter((item) => {
				const matchesSearch = this.filterBillingsBySearch(item, searchValue);
				return item.status === 'unpaid' && item.identifier === 'systemtax' && item.overduestatus === 'false' && item.targetidentifier === this.PlayerData.identifier && matchesSearch;
			});
		},

		GetPaidTaxesLength() {
			if (!this.validateBillingData()) return 0;

			return Object.values(this.PlayerData.billing).reduce((total, item) => {
				if (item.status === 'paid' && item.identifier === 'systemtax' && item.targetidentifier === this.PlayerData.identifier) {
					return total + 1;
				}
				return total;
			}, 0);
		},

		GetUnpaidTaxesLength() {
			if (!this.validateBillingData()) return 0;

			return Object.values(this.PlayerData.billing).reduce((total, item) => {
				if (item.status === 'unpaid' && item.identifier === 'systemtax' && item.targetidentifier === this.PlayerData.identifier) {
					return total + 1;
				}
				return total;
			}, 0);
		},

		GetUnpaidAndPaidTaxesTotalLength() {
			return this.GetPaidTaxesLength + this.GetUnpaidTaxesLength;
		},

		GetPaidBills() {
			if (!this.validateBillingData()) return [];
			const searchValue = this.Models.PaidBills.toLowerCase();
			return Object.values(this.PlayerData.billing)
				.filter((item) => {
					const baseFilter = item.status === 'paid' && item.targetidentifier === this.PlayerData.identifier;

					if (!baseFilter) return false;
					const matchesSearch = this.filterBillingsBySearch(item, searchValue);

					return matchesSearch;
				})
				.sort((a, b) => {
					return parseInt(b.date) - parseInt(a.date);
				});
		},
		GetOnOverDueBills() {
			if (!this.validateBillingData()) return [];

			const searchValue = this.Models.OnOverDue.toLowerCase();
			return Object.values(this.PlayerData.billing).filter((item) => {
				const matchesSearch = this.filterBillingsBySearch(item, searchValue);
				return item.overduestatus === 'true' && item.status === 'unpaid' && item.targetidentifier === this.PlayerData.identifier && matchesSearch;
			});
		},

		GetAwaitingBills() {
			if (!this.validateBillingData()) return [];

			const searchValue = this.Models.AwaitingPayments.toLowerCase();
			return Object.values(this.PlayerData.billing).filter((item) => {
				const matchesSearch = this.filterBillingsBySearch(item, searchValue);
				return item.status === 'unpaid' && item.identifier === this.PlayerData.identifier && matchesSearch;
			});
		},

		SubtotalPayAll() {
			if (this.PayAllBills.length > 0) {
				return this.PayAllBills.reduce((acc, item) => acc + parseInt(item.amount), 0);
			} else {
				return 0;
			}
		},
	},

	watch: {
		CreateBillModal: {
			immediate: false,
			handler(value) {
				if (!value) return;

				this.resetBillingForm();
				this.initializeCreateBill();
			},
		},
		currentPage: {
			immediate: false,
			handler(value) {
				if (value === 'dashboard') {
					this.$nextTick(this.CreateChartPersonel);
				}
			},
		},
		UpdateSpend: {
			immediate: false,
			handler(value) {
				if (value && this.currentPage === 'dashboard') {
					this.CreateChartPersonel();
				}
			},
		},
	},

	components: {},
	beforeUnmount() {
		window.removeEventListener('keyup', this.keyHandler);
		window.removeEventListener('message', this.eventHandler);

		this.OpenPersonelPage = false;
	},

	mounted() {
		window.addEventListener('message', this.eventHandler);
		window.addEventListener('keyup', this.keyHandler);
		this.OpenPersonelPage = true;
		setTimeout(() => {
			this.CreateChartPersonel();
		}, 100);
	},
};
