import importTemplate from '../../js/util/importTemplate.js';
import { getBusinessChartConfig } from './chartConfig.js';

export default {
	template: await importTemplate('pages/businesspage/index.html'),

	data: () => ({
		category: [
			{
				name: 'dashboard',
			},
			{
				name: 'awatingpayments',
			},
			{
				name: 'paidbills',
			},
			{
				name: 'taxes',
			},
			{
				name: 'billtemplate',
			},
			{
				name: 'billvault',
			},
		],
		currentPage: 'dashboard',
		ActiveModal: '',
		CreateBillingPage: '',
		Models: {
			vaultamount: '',
			searchlog: '',
			billingtemplatename: '',
			CreateBillingPlayerID: '',
			BillingReason: '',
			BillingAmount: '',
			searchtemplate: '',
			searchemploye: '',
			AwaitingPayments: '',
			BusinessLogo: '',
			TaxesBills: '',
			PaidBills: '',
		},
		CreateBillingData: {
			reasons: [],
			targetplayerdata: [],
		},
		NearbyPlayers: [],
		ShowLoadingBar: false,
		NearbySwiperValue: null,
		tooltip: {
			visible: false,
			text: '',
			x: 0,
			y: 0,
			index: null,
		},
		DeleteTemplateID: false,
		BusinessPageChart: null,
		OpacityValue: -1,
		EditTemplateData: false,
		ShowChangeLogoIcon: false,
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
		toggleBusinessAccess(value, type, e) {
			if (value.identifier === this.PlayerData.identifier) {
				this.$store.dispatch('TabletNotification', {
					message: this.Locales['ownpermission'],
					type: 'info',
				});
				value.permission[type] = !value.permission[type];
				e.target.checked = value.permission[type];
				return;
			}
			if (value.permission.boss) {
				this.$store.dispatch('TabletNotification', {
					message: this.Locales['cannotchangepermission'],
					type: 'info',
				});
				value.permission[type] = !value.permission[type];
				e.target.checked = value.permission[type];
				return;
			}
			postNUI('toggleBusinessAccess', {
				identifier: value.identifier,
				type: type,
			});
		},
		ShowButton(name) {
			if (!this.$store.state.JobsData?.personels?.[this.PlayerData.identifier]?.permission) {
				return false;
			}

			const permission = this.$store.state.JobsData.personels[this.PlayerData.identifier].permission;
			switch (name) {
				case 'dashboard':
					return true;
				case 'paidbills':
					return permission.accestobussiness;
				case 'awatingpayments':
					return permission.accestobussiness;
				case 'taxes':
					return permission.accestobussiness;
				case 'billtemplate':
					return permission.accestobussiness;
				case 'billvault':
					return permission.boss;
				case 'billpermission':
					return permission.boss;

				default:
					return false;
			}
		},
		GetTemplateAmount(value) {
			let amount = 0;
			for (let i = 0; i < value.length; i++) {
				amount += Number(value[i].amount);
			}
			return amount;
		},
		AddBillingTemplateReason() {
			if (!this.EditTemplateData) return;
			if (this.Models.BillingReason.length <= 0 || this.Models.BillingAmount.length <= 0) {
				this.$store.dispatch('TabletNotification', {
					message: this.Locales['pleasefillthedetails'],
					type: 'info',
				});
				return;
			}

			postNUI('AddBillingTemplateReason', {
				reason: this.Models.BillingReason,
				amount: this.Models.BillingAmount,
				uniqueid: this.EditTemplateData.uniqueid,
			});

			this.Models.BillingReason = '';
			this.Models.BillingAmount = '';
		},
		ChangeBusinessLogo() {
			if (this.Models.BusinessLogo.length <= 0) {
				return;
			}
			if (this.Models.BusinessLogo.length > 400) {
				this.$store.dispatch('TabletNotification', {
					message: this.Locales['linktoolong'],
					type: 'error',
				});
				return;
			}

			const image = new Image();
			image.onload = () => {
				postNUI('ChangeBusinessLogo', this.Models.BusinessLogo);
				this.CloseActiveModal();
			};
			image.onerror = () => {
				this.$store.dispatch('TabletNotification', {
					message: this.Locales['invalidimageurl'],
					type: 'error',
				});
			};

			image.src = this.Models.BusinessLogo;
		},
		ChangeLogo() {
			if (this.$store.state.JobsData.personels) {
				if (this.$store.state.JobsData.personels[this.PlayerData.identifier]) {
					let permission = this.$store.state.JobsData.personels[this.PlayerData.identifier].permission;
					if (permission.accestobussiness) {
						this.ActiveModal = 'changelogo';
					}
				}
			}
		},
		GetTextColor(value) {
			if (value == 'transfetobusinessvault') {
				return '#54e8b1';
			}
			if (value == 'deposittovault') {
				return '#A054E8';
			}

			if (value == 'transfertobank') {
				return '#548de8';
			}
		},
		eventHandler(event) {
			switch (event.data.action) {
				case 'UPDATE_OWNER_TEMPLATE':
					let JobName5 = event.data.payload.jobname;
					let Uniqueid = event.data.payload.uniqueid;
					let Reasonid = event.data.payload.reasonid;

					if (this.$store.state.JobsData && this.$store.state.JobsData.jobname === JobName5) {
						this.$store.state.JobsData.template.forEach((template) => {
							if (template.uniqueid === Uniqueid) {
								template.template = template.template.filter((item) => item.id !== Reasonid);
								this.EditTemplateData.template = template.template;
								if (this.EditTemplateData.template.length == 0) {
									postNUI('DeleteTemplate', this.EditTemplateData.uniqueid);
									this.CloseActiveModal();
								}
							}
						});
					}
					break;
				default:
					break;
			}
		},
		RemoveEditTemplateReason(id) {
			postNUI('UpdateTemplate', {
				uniqueid: this.EditTemplateData.uniqueid,
				reasonid: id,
			});
		},
		RemoveTemplateReason(id) {
			postNUI('UpdateTemplate', {
				uniqueid: this.EditTemplateData.uniqueid,
				reasonid: id,
			});
		},
		PayBills(value) {
			postNUI('PayBills', value);
		},
		CancelJobAwaitingBill(value) {
			if (!value) return;
			postNUI('CancelJobAwaitingBill', value);
		},
		ChangeOpacity(value) {
			this.OpacityValue = value;
		},
		SelectBillignTemplate(value) {
			this.CreateBillingData.reasons = value.template;
			setTimeout(() => {
				this.CreateBillingPage = 'createbill2';
			}, 250);
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
		DeleteTemplateModal() {
			if (!this.DeleteTemplateID) {
				return;
			}
			postNUI('DeleteTemplate', this.DeleteTemplateID);
			this.DeleteTemplateID = false;
		},

		DeleteTemplate(value) {
			this.DeleteTemplateID = value;
		},
		SaveBillingTemplate() {
			if (this.CreateBillingData.reasons.length <= 0) {
				this.$store.dispatch('TabletNotification', {
					message: this.Locales['pleasefillthedetails'],
					type: 'info',
				});
				return;
			}
			if (this.Models.billingtemplatename.length <= 0) {
				this.$store.dispatch('TabletNotification', {
					message: this.Locales['pleasefillthename'],
					type: 'info',
				});
				return;
			}

			postNUI('SaveBillingTemplate', { name: this.Models.billingtemplatename, reasons: this.CreateBillingData.reasons });
			this.CloseActiveModal();
		},
		RemoveBillingReason(id) {
			this.CreateBillingData.reasons = this.CreateBillingData.reasons.filter((reason) => reason.id !== id);
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

		prepareChartData() {
			return {
				incoming: [
					this.JobsData.spenddata.incoming.mon || 0,
					this.JobsData.spenddata.incoming.tue || 0,
					this.JobsData.spenddata.incoming.wed || 0,
					this.JobsData.spenddata.incoming.thu || 0,
					this.JobsData.spenddata.incoming.fri || 0,
					this.JobsData.spenddata.incoming.sat || 0,
					this.JobsData.spenddata.incoming.sun || 0,
				],
				outgoing: [
					this.JobsData.spenddata.outgoing.mon || 0,
					this.JobsData.spenddata.outgoing.tue || 0,
					this.JobsData.spenddata.outgoing.wed || 0,
					this.JobsData.spenddata.outgoing.thu || 0,
					this.JobsData.spenddata.outgoing.fri || 0,
					this.JobsData.spenddata.outgoing.sat || 0,
					this.JobsData.spenddata.outgoing.sun || 0,
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
			this.BusinessPageChart = new Chart(ctx, getBusinessChartConfig(data, chartLocales));
		},

		async CreateChartBusiness() {
			if (this.currentPage !== 'dashboard' || !this.OpenBusinessPage) {
				return;
			}
			this.ShowChartLoadingBar = true;
			if (this.BusinessPageChart) this.BusinessPageChart.destroy();

			try {
				const ctx = document.getElementById('businessPageChart');
				if (!ctx || !ctx.offsetWidth || !ctx.offsetHeight) {
					console.log('Canvas is not ready.. Again trying..');
					setTimeout(() => this.CreateChartBusiness(), 100);
					return;
				}

				const chartData = this.prepareChartData();
				setTimeout(() => {
					if (!this.OpenBusinessPage) return;
					this.initializeChart(ctx, chartData);
					this.ShowChartLoadingBar = false;
				}, 750);
			} catch (error) {
				console.log('Chart creation error:', error);
				this.ShowChartLoadingBar = false;
			}
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
					message: this.Locales['nojobidplayer'],
					type: 'error',
				});
				return;
			}
		},
		ChangeCreateBillingPage(value) {
			if (this.CreateBillingPage == 'selecttemplate' && value == 'createbill2') {
				this.CreateBillingPage = value;
				return;
			}

			if (value == 'selecttemplate') {
				this.CreateBillingPage = value;
				return;
			}

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
				postNUI('CreateJobBilling', this.CreateBillingData);
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
							message: this.Locales['nojobidplayer'],
							type: 'error',
						});
						return;
					}
				}
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
		handleMoneyTransfer(type) {
			if (this.Models.vaultamount === '' || this.Models.vaultamount <= 0) {
				this.$store.dispatch('TabletNotification', {
					message: this.Locales['pleasefilltheamount'],
					type: 'error',
				});
				return;
			}

			const transferTypes = {
				bank: 'TransferToBankAccount',
				vault: 'DepositToVault',
				business: 'TransferToBusinessVault',
			};

			const action = transferTypes[type];
			if (action) {
				postNUI(action, this.Models.vaultamount);
				this.Models.vaultamount = '';
			}
		},
		checkInput() {
			if (this.Models.vaultamount.length > 0) {
				this.Models.vaultamount = this.Models.vaultamount.replace(/[^0-9]/g, '');
			}
			if (this.Models.BillingAmount.length > 0) {
				this.Models.BillingAmount = this.Models.BillingAmount.replace(/[^0-9]/g, '');
			}
		},

		ChangePage(value) {
			this.currentPage = value;
		},
		CloseActiveModal() {
			this.EditTemplateData = false;
			this.CreateBillingData.reasons = [];
			this.CreateBillingData.targetplayerdata = [];
			this.Models.BusinessLogo = '';
			this.ActiveModal = '';
			this.$store.dispatch('SetShowNavbar', true);
		},
		ChangeActiveModel(value) {
			if (value == 'createtemplate') {
				this.Models.billingtemplatename = '';
				this.ActiveModal = value;
			} else {
				this.$store.dispatch('SetShowNavbar', false);
				this.ActiveModal = value;
			}
		},
		filterBillingsBySearch(item, searchValue) {
			if (!searchValue || searchValue.trim() === '') return true;
			const searchableFields = [
				item.targetname?.toLowerCase(),
				item.invoiceid?.toLowerCase(),
				item.identifiername?.toLowerCase(),
				item.formatdate?.toLowerCase(),
				item.formatoverduedate?.toLowerCase(),

				item.amount?.toString(),
				item.totalAmount?.toString(),

				item.billtype?.toLowerCase(),
				item.identifier?.toLowerCase(),
			];

			if (item.reason && Array.isArray(item.reason)) {
				item.reason.forEach((r) => {
					searchableFields.push(r.reason?.toLowerCase());
					searchableFields.push(r.amount?.toString());
				});
			}
			return searchableFields.some((field) => field && field.includes(searchValue));
		},
	},

	computed: {
		...Vuex.mapState({
			currencyUnit: (state) => state.currencyUnit,
			PlayerData: (state) => state.PlayerData,
			JobsData: (state) => state.JobsData,
			CreateBillModal: (state) => state.CreateBillModal,
			BillingTax: (state) => state.BillingTax,
			OverDueDate: (state) => state.OverDueDate,
			UpdateJobSpend: (state) => state.UpdateJobSpend,
			ServerTaxes: (state) => state.ServerTaxes,
			Locales: (state) => state.Locales,
		}),

		Getjoblog() {
			const searchValue = this.Models.searchlog ? this.Models.searchlog.toLowerCase() : '';
			return Object.values(this.JobsData.log).filter((item) => {
				const amountString = item.amount?.toString().toLowerCase() || '';
				const labelString = item.label?.toLowerCase() || '';
				return !searchValue || amountString.includes(searchValue) || labelString.includes(searchValue);
			});
		},
		GetJobTemplate() {
			const searchValues = this.Models.searchtemplate ? this.Models.searchtemplate.toLowerCase() : '';
			return this.JobsData.template.filter((item) => {
				const labelString = item.name?.toLowerCase() || '';
				return !searchValues || labelString.includes(searchValues);
			});
		},
		GetSubtotalCreateBillingAmount() {
			if (this.CreateBillingData.reasons.length > 0) {
				return this.CreateBillingData.reasons.reduce((acc, item) => acc + parseInt(item.amount), 0);
			} else {
				return 0;
			}
		},
		GetSubtotalCreateBillingAmountWithTax() {
			if (this.CreateBillingData.reasons.length > 0) {
				const subtotal = this.CreateBillingData.reasons.reduce((acc, item) => acc + parseFloat(item.amount || 0), 0);
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

		GetJobPlayers() {
			if (this.JobsData && this.JobsData.personels) {
				const seachValue = this.Models.searchemploye ? this.Models.searchemploye.toLowerCase() : '';
				if (Object.values(this.JobsData.personels).length <= 0) return [];

				return Object.values(this.JobsData.personels).filter((item) => {
					const name = item.name.toLowerCase();
					return !seachValue || name.includes(seachValue);
				});
			}
		},
		GetAwaitingBills() {
			let SearchValues = this.Models.AwaitingPayments.toLowerCase();

			return Object.values(this.JobsData.billing).filter((item) => {
				const matchesSearch = !SearchValues || item.identifiername.toLowerCase().includes(SearchValues) || item.invoiceid.toLowerCase().includes(SearchValues);

				return item.status === 'unpaid' && item.identifier !== 'systemtax' && matchesSearch;
			});
		},
		GetTemplateSubtotal() {
			if (this.EditTemplateData) {
				if (this.EditTemplateData.template.length > 0) {
					return this.EditTemplateData.template.reduce((acc, item) => acc + parseFloat(item.amount), 0);
				} else {
					return 0;
				}
			} else {
				return 0;
			}
		},
		GetAllTotalTemplate() {
			if (this.EditTemplateData) {
				if (this.EditTemplateData.template.length > 0) {
					const subtotal = this.EditTemplateData.template.reduce((acc, item) => acc + parseFloat(item.amount || 0), 0);
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
			} else {
				return 0;
			}
		},
		GetTaxesBill() {
			if (!this.JobsData || !this.JobsData.billing) return [];
			const searchValue = this.Models.TaxesBills.toLowerCase();
			return Object.values(this.JobsData.billing).filter((item) => {
				const matchesSearch = !searchValue || item.identifiername.toLowerCase().includes(searchValue) || item.invoiceid.toLowerCase().includes(searchValue);

				return item.status === 'unpaid' && item.identifier === 'systemtax' && matchesSearch;
			});
		},
		GetBusinessServerTaxes() {
			return Object.values(this.ServerTaxes).filter((item) => item.type == 'business');
		},
		GetPaidBills() {
			if (!this.JobsData || !this.JobsData.billing) return [];
			const searchValue = this.Models.PaidBills.toLowerCase();
			return Object.values(this.JobsData.billing)
				.filter((item) => {
					const baseFilter = item.status === 'paid' && item.identifier !== 'systemtax';

					if (!baseFilter) return false;
					const matchesSearch = this.filterBillingsBySearch(item, searchValue);

					return matchesSearch;
				})
				.sort((a, b) => {
					return parseInt(b.date) - parseInt(a.date);
				});
		},
		GetPaidBillingTotalAmount() {
			if (this.GetPaidBills.length > 0) {
				return this.GetPaidBills.length;
			} else {
				return 0;
			}
		},

		GetUnPaidBillingTotalAmount() {
			if (this.GetAwaitingBills.length > 0) {
				return this.GetAwaitingBills.length;
			} else {
				return 0;
			}
		},
		GetTaxesBillTotalAmount() {
			if (this.GetTaxesBill.length > 0) {
				return this.GetTaxesBill.length;
			} else {
				return 0;
			}
		},

		GetTaxesUnPaidTotalAmount() {
			let amount = 0;
			Object.values(this.JobsData.billing).filter((item) => {
				if (item.status === 'unpaid' && item.identifier === 'systemtax') {
					amount += 1;
				}
			});
			return amount;
		},
	},

	watch: {
		CreateBillModal(value) {
			if (value) {
				this.ActiveModal = 'createbill';
				this.CreateBillingPage = 'createbill1';
				this.$store.dispatch('SetShowNavbar', false);
				this.$store.dispatch('SetCreateBillingModal', false);

				this.Models.CreateBillingPlayerID = '';
				this.Models.BillingReason = '';
				this.Models.BillingAmount = '';
				this.NearbyPlayers = [];
				this.CreateBillingData = {
					reasons: [],
					targetplayerdata: [],
				};

				this.GetNearbyPlayers();
			}
		},
		currentPage(value) {
			if (value == 'dashboard') {
				setTimeout(() => {
					this.CreateChartBusiness();
				}, 100);
			}
		},
		UpdateJobSpend(value) {
			if (value) {
				this.CreateChartBusiness();
			}
		},
	},

	components: {},
	beforeUnmount() {
		window.removeEventListener('keyup', this.keyHandler);
		window.removeEventListener('message', this.eventHandler);
		this.OpenBusinessPage = false;
	},

	mounted() {
		window.addEventListener('message', this.eventHandler);
		window.addEventListener('keyup', this.keyHandler);
		this.currentPage = 'dashboard';
		this.OpenBusinessPage = true;
		setTimeout(() => {
			this.CreateChartBusiness();
		}, 100);
	},
};
