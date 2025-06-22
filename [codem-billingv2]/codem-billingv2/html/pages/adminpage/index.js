import importTemplate from '../../js/util/importTemplate.js';
import { getAdminPageChartConfig } from './chartConfig.js';
export default {
	template: await importTemplate('pages/adminpage/index.html'),

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
				name: 'applications',
				children: [
					{ name: 'subCategory1', label: 'Sub Category 1' },
					{ name: 'subCategory2', label: 'Sub Category 2' },
				],
			},
			{
				name: 'taxes',
			},
			{
				name: 'adminlog',
			},
			{
				name: 'authorized',
			},
		],
		currentPage: 'dashboard',
		ActiveModal: '',
		CreateBillingPage: '',
		ApplicationPage: 'individuals',
		Models: {
			Individuals: '',
			AdminLog: '',
			Business: '',
			Authorized: '',
			AuthorizedBusiness: '',
			Authourizeid: '',
			AllBilling: '',
			PaidBills: '',
		},
		TaxesPageData: {
			ToCitizenPage: {
				EditingPage: false,
				DeletePage: false,
				AllTaxesPage: false,
				CreateNewTax: false,
				EditingPageModels: {
					hours: '',
					minutes: '',
					amount: '',
					label: '',
				},
				CreateTaxModels: {
					label: '',
					amount: '',
					hours: '',
					minutes: '',
				},
			},
			ToBusinessPage: {
				EditingPage: false,
				DeletePage: false,
				AllTaxesPage: false,
				CreateNewTax: false,
				EditingPageModels: {
					hours: '',
					minutes: '',
					amount: '',
					label: '',
				},
				CreateTaxModels: {
					label: '',
					amount: '',
					hours: '',
					minutes: '',
				},
			},
		},
		DeleteUnauthorize: false,
		TaxesPageSwiperValue: null,

		OpacityValue: -1,
		tooltip: {
			visible: false,
			text: '',
			x: 0,
			y: 0,
			index: null,
		},
		CancelBillingID: false,
		AdminPageChart: null,
		OpenAdminPage: false,
		ShowChartLoadingBar: true,
		BusinessTaxesPageSwiperValue: null,
		visibleCount: 8,
		loading: false,
		visibleCount2: 8,
		loading2: false,
	}),
	methods: {
		handleScroll() {
			const container = this.$refs.scrollContainer;
			if (container.scrollTop + container.clientHeight >= container.scrollHeight - 10) {
				this.loadMore();
			}
		},
		loadMore() {
			if (this.loading) return;
			if (this.visibleCount >= this.GetUnpaidBilling.length) return;
			this.loading = true;
			setTimeout(() => {
				this.visibleCount += 8;
				this.loading = false;
			}, 500);
		},
		handleScroll2() {
			const container = this.$refs.scrollContainer2;
			if (container.scrollTop + container.clientHeight >= container.scrollHeight - 10) {
				this.loadMore2();
			}
		},
		loadMore2() {
			if (this.loading2) return;
			if (this.visibleCount2 >= this.GetPaidBills.length) return;
			this.loading2 = true;
			setTimeout(() => {
				this.visibleCount2 += 8;
				this.loading2 = false;
			}, 500);
		},
		prepareChartData() {
			return {
				incoming: [
					this.AdminData.SpendData.mon || 0,
					this.AdminData.SpendData.tue || 0,
					this.AdminData.SpendData.wed || 0,
					this.AdminData.SpendData.thu || 0,
					this.AdminData.SpendData.fri || 0,
					this.AdminData.SpendData.sat || 0,
					this.AdminData.SpendData.sun || 0,
				],
			};
		},

		initializeChart(ctx, data) {
			Chart.defaults.color = '#646365';
			Chart.defaults.fontFamily = 'gilroybold';
			this.AdminPageChart = new Chart(ctx, getAdminPageChartConfig(data));
		},

		async CreateAdminPageChart() {
			if (this.currentPage !== 'dashboard' || !this.OpenAdminPage) {
				return;
			}
			this.ShowChartLoadingBar = true;
			if (this.AdminPageChart) this.AdminPageChart.destroy();

			try {
				const ctx = document.getElementById('adminPageChart');
				if (!ctx || !ctx.offsetWidth || !ctx.offsetHeight) {
					console.log('Canvas not found again trying.');
					setTimeout(() => this.CreateAdminPageChart(), 100);
					return;
				}

				const chartData = this.prepareChartData();
				setTimeout(() => {
					if (!this.OpenAdminPage) return;
					this.initializeChart(ctx, chartData);
					this.ShowChartLoadingBar = false;
				}, 750);
			} catch (error) {
				console.log('Chart creation error:', error);
				this.ShowChartLoadingBar = false;
			}
		},

		CancelBilling() {
			if (!this.CancelBillingID) return;
			postNUI('CancelAdminAwaitingBill', this.CancelBillingID);
		},
		ChangeOpacity(value) {
			this.OpacityValue = value;
		},
		AuthorizeBusiness() {
			if (this.Models.AuthorizedBusiness.length <= 0) {
				return;
			}
			postNUI('authorizeBusiness', this.Models.AuthorizedBusiness);
			this.Models.AuthorizedBusiness = '';
			this.CloseActiveModal();
		},
		DeletePlayerUnauthorize() {
			if (!this.DeleteUnauthorize) {
				return;
			}
			postNUI('deletePlayerUnauthorize', this.DeleteUnauthorize);
			this.DeleteUnauthorize = false;
		},
		translate(key, params = {}) {
			const localizedString = this.Locales[key] || key;
			return localizedString
				.replace('${name}', `<span class="text-[#54E8B2]">${params.name || ''}</span>`)
				.replace('${amount}', `<span class="text-[#54E8B2]">${params.amount || ''}</span>`)
				.replace('${currencyUnit}', `<span class="text-[#54E8B2]">${this.currencyUnit || ''}</span>`)
				.replace('${hours}', `<span class="text-[#54E8B2]">${params.hours || ''}</span>`)
				.replace('${minutes}', `<span class="text-[#54E8B2]">${params.minutes || ''}</span>`);
		},
		CreateNewTax(value) {
			let Taxeslabel = this.TaxesPageData[value].CreateTaxModels.label;
			let Taxesamount = this.TaxesPageData[value].CreateTaxModels.amount;
			let Taxeshours = this.TaxesPageData[value].CreateTaxModels.hours;
			let Taxessminutes = this.TaxesPageData[value].CreateTaxModels.minutes;

			if (Taxeslabel.length <= 0 || Taxesamount.length <= 0 || Taxeshours.length <= 0 || Taxessminutes.length <= 0) {
				return;
			}

			postNUI('createNewTax', {
				label: Taxeslabel,
				amount: Taxesamount,
				hours: Taxeshours,
				minutes: Taxessminutes,
				type: value === 'ToCitizenPage' ? 'citizen' : 'business',
			});

			this.TaxesPageData[value].CreateNewTax = false;
		},
		SaveEditingPage(value) {
			let TaxesID = this.TaxesPageData[value].EditingPage.uniqueid;
			let label = this.TaxesPageData[value].EditingPageModels.label;
			let amount = this.TaxesPageData[value].EditingPageModels.amount;
			let hours = this.TaxesPageData[value].EditingPageModels.hours;
			let minutes = this.TaxesPageData[value].EditingPageModels.minutes;

			let ModelLabel = this.TaxesPageData[value].EditingPage.label;
			let ModelAmount = this.TaxesPageData[value].EditingPage.amount;
			let ModelHours = this.TaxesPageData[value].EditingPage.hours;
			let ModelMinutes = this.TaxesPageData[value].EditingPage.minutes;

			if (ModelLabel === label && ModelAmount === amount && ModelHours === hours && ModelMinutes === minutes) {
				this.OpenEditingPage(value, false);
				return;
			} else {
				if (ModelLabel.length <= 0 || ModelAmount.length <= 0 || ModelHours.length <= 0 || ModelMinutes.length <= 0) {
					this.OpenEditingPage(value, false);
					return;
				}
				postNUI('saveEditingPage', {
					uniqueid: TaxesID,
					label: label,
					amount: amount,
					hours: hours,
					minutes: minutes,
				});
				this.OpenEditingPage(value, false);
			}
		},
		ChangeTaxActive(value) {
			postNUI('changeTaxActive', value);
		},
		TaxesSwiper() {
			this.TaxesPageSwiperValue = new Swiper('#TaxesPageSwiper', {
				slidesPerView: 1,
				loop: false,
				slidesPerGroup: 1,
				spaceBetween: 10,

				navigation: {
					nextEl: '.nextbutton',
					prevEl: '.prevbutton',
				},
			});
		},
		BusinessTaxesSwiper() {
			this.BusinessTaxesPageSwiperValue = new Swiper('#TaxesBusinessPageSwiper', {
				slidesPerView: 1,
				loop: false,
				slidesPerGroup: 1,
				spaceBetween: 10,
				navigation: {
					nextEl: '.nextbutton2',
					prevEl: '.prevbutton2',
				},
			});
		},
		AuthorizePlayer() {
			if (this.Models.Authourizeid.length <= 0) {
				return;
			}
			postNUI('authorizePlayer', this.Models.Authourizeid);
			this.CloseActiveModal();
		},
		checkInput() {
			if (this.Models.Authourizeid.length > 0) {
				this.Models.Authourizeid = this.Models.Authourizeid.replace(/[^0-9]/g, '');
			}
			if (this.TaxesPageData.ToCitizenPage.EditingPageModels.amount.length > 0) {
				this.TaxesPageData.ToCitizenPage.EditingPageModels.amount = this.TaxesPageData.ToCitizenPage.EditingPageModels.amount.replace(/[^0-9]/g, '');
			}
			if (this.TaxesPageData.ToCitizenPage.EditingPageModels.hours.length > 0) {
				this.TaxesPageData.ToCitizenPage.EditingPageModels.hours = this.TaxesPageData.ToCitizenPage.EditingPageModels.hours.replace(/[^0-9]/g, '');
			}
			if (this.TaxesPageData.ToCitizenPage.EditingPageModels.hours.length > 2) {
				this.TaxesPageData.ToCitizenPage.EditingPageModels.hours = this.TaxesPageData.ToCitizenPage.EditingPageModels.hours.slice(0, 2);
			}
			if (this.TaxesPageData.ToCitizenPage.EditingPageModels.minutes.length > 0) {
				this.TaxesPageData.ToCitizenPage.EditingPageModels.minutes = this.TaxesPageData.ToCitizenPage.EditingPageModels.minutes.replace(/[^0-9]/g, '');
			}
			if (this.TaxesPageData.ToCitizenPage.EditingPageModels.minutes.length > 2) {
				this.TaxesPageData.ToCitizenPage.EditingPageModels.minutes = this.TaxesPageData.ToCitizenPage.EditingPageModels.minutes.slice(0, 2);
			}

			if (this.TaxesPageData.ToCitizenPage.CreateTaxModels.hours.length > 0) {
				this.TaxesPageData.ToCitizenPage.CreateTaxModels.hours = this.TaxesPageData.ToCitizenPage.CreateTaxModels.hours.replace(/[^0-9]/g, '');
			}

			if (this.TaxesPageData.ToCitizenPage.CreateTaxModels.hours.length > 2) {
				this.TaxesPageData.ToCitizenPage.CreateTaxModels.hours = this.TaxesPageData.ToCitizenPage.CreateTaxModels.hours.slice(0, 2);
			}

			if (this.TaxesPageData.ToCitizenPage.CreateTaxModels.minutes.length > 0) {
				this.TaxesPageData.ToCitizenPage.CreateTaxModels.minutes = this.TaxesPageData.ToCitizenPage.CreateTaxModels.minutes.replace(/[^0-9]/g, '');
			}

			if (this.TaxesPageData.ToCitizenPage.CreateTaxModels.minutes.length > 2) {
				this.TaxesPageData.ToCitizenPage.CreateTaxModels.minutes = this.TaxesPageData.ToCitizenPage.CreateTaxModels.minutes.slice(0, 2);
			}

			if (this.TaxesPageData.ToCitizenPage.CreateTaxModels.amount.length > 0) {
				this.TaxesPageData.ToCitizenPage.CreateTaxModels.amount = this.TaxesPageData.ToCitizenPage.CreateTaxModels.amount.replace(/[^0-9]/g, '');
			}

			if (this.TaxesPageData.ToBusinessPage.EditingPageModels.amount.length > 0) {
				this.TaxesPageData.ToBusinessPage.EditingPageModels.amount = this.TaxesPageData.ToBusinessPage.EditingPageModels.amount.replace(/[^0-9]/g, '');
			}
			if (this.TaxesPageData.ToBusinessPage.EditingPageModels.hours.length > 0) {
				this.TaxesPageData.ToBusinessPage.EditingPageModels.hours = this.TaxesPageData.ToBusinessPage.EditingPageModels.hours.replace(/[^0-9]/g, '');
			}
			if (this.TaxesPageData.ToBusinessPage.EditingPageModels.hours.length > 2) {
				this.TaxesPageData.ToBusinessPage.EditingPageModels.hours = this.TaxesPageData.ToBusinessPage.EditingPageModels.hours.slice(0, 2);
			}
			if (this.TaxesPageData.ToBusinessPage.EditingPageModels.minutes.length > 0) {
				this.TaxesPageData.ToBusinessPage.EditingPageModels.minutes = this.TaxesPageData.ToBusinessPage.EditingPageModels.minutes.replace(/[^0-9]/g, '');
			}
			if (this.TaxesPageData.ToBusinessPage.EditingPageModels.minutes.length > 2) {
				this.TaxesPageData.ToBusinessPage.EditingPageModels.minutes = this.TaxesPageData.ToBusinessPage.EditingPageModels.minutes.slice(0, 2);
			}

			if (this.TaxesPageData.ToBusinessPage.CreateTaxModels.hours.length > 0) {
				this.TaxesPageData.ToBusinessPage.CreateTaxModels.hours = this.TaxesPageData.ToBusinessPage.CreateTaxModels.hours.replace(/[^0-9]/g, '');
			}

			if (this.TaxesPageData.ToBusinessPage.CreateTaxModels.hours.length > 2) {
				this.TaxesPageData.ToBusinessPage.CreateTaxModels.hours = this.TaxesPageData.ToBusinessPage.CreateTaxModels.hours.slice(0, 2);
			}

			if (this.TaxesPageData.ToBusinessPage.CreateTaxModels.minutes.length > 0) {
				this.TaxesPageData.ToBusinessPage.CreateTaxModels.minutes = this.TaxesPageData.ToBusinessPage.CreateTaxModels.minutes.replace(/[^0-9]/g, '');
			}

			if (this.TaxesPageData.ToBusinessPage.CreateTaxModels.minutes.length > 2) {
				this.TaxesPageData.ToBusinessPage.CreateTaxModels.minutes = this.TaxesPageData.ToBusinessPage.CreateTaxModels.minutes.slice(0, 2);
			}

			if (this.TaxesPageData.ToBusinessPage.CreateTaxModels.amount.length > 0) {
				this.TaxesPageData.ToBusinessPage.CreateTaxModels.amount = this.TaxesPageData.ToBusinessPage.CreateTaxModels.amount.replace(/[^0-9]/g, '');
			}
		},
		OpenCreateTax(value, type) {
			this.TaxesPageData[value].CreateNewTax = type;
		},
		OpenAllTaxesPage(value, type) {
			this.TaxesPageData[value].AllTaxesPage = type;
		},
		OpenDeletePage(value, type, variable) {
			if (variable) {
				let filter = Object.values(this.ServerTaxes).filter((item) => item.uniqueid === variable);
				if (filter.length > 0) {
					if (filter[0].system == 'yes') {
						this.$store.dispatch('TabletNotification', {
							message: this.Locales['taxnotdeleted'],
							type: 'info',
						});
						return;
					} else {
						this.TaxesPageData[value].DeletePage = variable;
					}
				} else {
					this.TaxesPageData[value].DeletePage = variable;
				}
			} else {
				this.TaxesPageData[value].DeletePage = type;
			}
		},
		DeleteTax() {
			let deleteTax = this.TaxesPageData.ToCitizenPage.DeletePage || this.TaxesPageData.ToBusinessPage.DeletePage;
			if (!deleteTax) {
				return;
			}
			postNUI('deleteTax', deleteTax);
			this.TaxesPageData.ToCitizenPage.DeletePage = false;
			this.TaxesPageData.ToBusinessPage.DeletePage = false;
		},
		OpenEditingPage(value, type, variable) {
			if (variable) {
				this.TaxesPageData[value].EditingPage = variable;
				this.TaxesPageData[value].EditingPageModels = {
					label: variable.label,
					amount: variable.amount,
					hours: variable.hours,
					minutes: variable.minutes,
				};
			} else {
				this.TaxesPageData[value].EditingPage = type;
			}
		},
		AcceptJobApplication(value) {
			postNUI('acceptJobApplication', value);
		},
		DeclineApplication(value) {
			postNUI('declineApplication', value);
		},
		AcceptApplication(value) {
			postNUI('acceptApplication', value);
		},
		OpenPersonelPage() {
			this.$store.dispatch('SetActivePage', 'personelpage');
			this.$store.dispatch('SetShowNavbar', true);
		},

		ChangeApplicationPage(value) {
			this.ApplicationPage = value;
		},
		ChangeCreateBillingPage(value) {
			this.CreateBillingPage = value;
		},
		ChangePage(value) {
			this.currentPage = value;
		},
		CloseActiveModal() {
			this.Models.Authourizeid = '';
			this.ActiveModal = '';
		},
		ChangeActiveModel(value) {
			this.ActiveModal = value;
		},
	},

	computed: {
		...Vuex.mapState({
			currencyUnit: (state) => state.currencyUnit,
			ApplicationsData: (state) => state.ApplicationsData,
			AdminData: (state) => state.AdminData,
			PlayerData: (state) => state.PlayerData,
			ServerTaxes: (state) => state.ServerTaxes,
			Locales: (state) => state.Locales,
			BillingTax: (state) => state.BillingTax,
			UpdateAdminSpend: (state) => state.UpdateAdminSpend,
		}),
		visibleUnpaidBilling() {
			return this.GetUnpaidBilling.slice(0, this.visibleCount);
		},
		visiblePaidBilling() {
			return this.GetPaidBills.slice(0, this.visibleCount2);
		},


		GetIndividualApplications() {
			const searchValue = this.Models.Individuals.toLowerCase();
			return Object.values(this.ApplicationsData).filter((item) => {
				const matchesSearch = !searchValue || item.name.toLowerCase().includes(searchValue);

				return item.type === 'individuals' && matchesSearch;
			});
		},

		GetBusinessApplications() {
			const searchValue2 = (this.Models.Business || '').toLowerCase();
			return Object.values(this.ApplicationsData).filter((item) => {
				const matchesSearch2 = !searchValue2 || item.joblabel.toLowerCase().includes(searchValue2);

				return item.type === 'business' && matchesSearch2;
			});
		},

		GetTotalLength() {
			return Object.values(this.ApplicationsData).length;
		},

		GetAdminLog() {
			const searchValue3 = (this.Models.AdminLog || '').toLowerCase();
			return this.AdminData.AllLogs.filter((item) => {
				const matchesSearch = !searchValue3 || item.targetname.toLowerCase().includes(searchValue3) || item.name.toLowerCase().includes(searchValue3);

				return matchesSearch;
			});
		},

		GetAllAuthorized() {
			const searchValue3 = (this.Models.Authorized || '').toLowerCase();
			return Object.values(this.AdminData.AllAuthorized)
				.map((entry) => entry.autdata)
				.filter((item) => {
					if (!item) return false;
					const targetName = item.targetname.toLowerCase();
					const personName = item.name.toLowerCase();

					return !searchValue3 || targetName.includes(searchValue3) || personName.includes(searchValue3);
				});
		},

		GetCitizenTaxes() {
			return Object.values(this.ServerTaxes).filter((item) => item.type === 'citizen');
		},
		GetBusinessTaxes() {
			return Object.values(this.ServerTaxes).filter((item) => item.type === 'business');
		},

		GetUnpaidBilling() {
			const searchValue4 = (this.Models.AllBilling || '').toLowerCase();
			return Object.values(this.AdminData.AllBilling).filter((item) => {
				if (item.status !== 'paid') {
					const matchesSearch = !searchValue4 || item.targetname.toLowerCase().includes(searchValue4) || item.name.toLowerCase().includes(searchValue4);
					return matchesSearch;
				}
			});
		},
		GetPaidBills() {
			const searchValue = this.Models.PaidBills.toLowerCase();
			return Object.values(this.AdminData.AllBilling).filter((item) => {
				if (item.status === 'paid') {
					const matchesSearch = !searchValue || item.targetname.toLowerCase().includes(searchValue) || item.name.toLowerCase().includes(searchValue);
					return matchesSearch;
				}
			});
		},

		GetAllBillingAdmin() {
			let amount = 0;

			if (!this.AdminData?.AllBilling) {
				return amount;
			}

			Object.values(this.AdminData.AllBilling).forEach((item) => {
				if (item.billtype !== 'system' && item.status === 'paid') {
					amount += 1;
				}
			});
			return amount;
		},

		GetAllBillingUnpaid() {
			let amount = 0;

			if (!this.AdminData?.AllBilling) {
				return amount;
			}

			Object.values(this.AdminData.AllBilling).forEach((item) => {
				if (item.status !== 'paid' && item.billtype !== 'system') {
					amount += 1;
				}
			});
			return amount;
		},

		GetAllBillingTaxAdmin() {
			let amount = 0;

			if (!this.AdminData?.AllBilling) {
				return amount;
			}

			Object.values(this.AdminData.AllBilling).forEach((item) => {
				if (item.billtype !== 'system' && item.status === 'paid') {
					amount += 1;
				}
			});
			return amount;
		},

		GetAllBillingTaxUnpaid() {
			let amount = 0;

			if (!this.AdminData?.AllBilling) {
				return amount;
			}

			Object.values(this.AdminData.AllBilling).forEach((item) => {
				if (item.status !== 'paid' && item.billtype === 'system') {
					amount += 1;
				}
			});
			return amount;
		},
	},

	watch: {
		'$store.state.UpdateTaxes': {
			immediate: false,
			handler(value) {
				if (this.currentPage == 'taxes') {
					setTimeout(() => {
						this.TaxesSwiper();
						this.BusinessTaxesSwiper();
					}, 200);
				}
			},
		},
		currentPage: {
			immediate: false,
			handler(value) {
				if (value === 'dashboard') {
					this.$nextTick(this.CreateAdminPageChart);
				}
				if (value === 'taxes') {
					setTimeout(() => {
						this.TaxesSwiper();
						this.BusinessTaxesSwiper();
					}, 200);
				}
			},
		},
		UpdateAdminSpend: {
			immediate: false,
			handler(value) {
				if (value && this.currentPage === 'dashboard') {
					this.CreateAdminPageChart();
				}
			},
		},
	},

	components: {},
	beforeUnmount() {
		window.removeEventListener('keyup', this.keyHandler);
		window.removeEventListener('message', this.eventHandler);
		this.OpenAdminPage = false;
	},

	mounted() {
		window.addEventListener('message', this.eventHandler);
		window.addEventListener('keyup', this.keyHandler);
		this.currentPage = 'dashboard';
		this.OpenAdminPage = true;
		setTimeout(() => {
			this.$nextTick(this.CreateAdminPageChart);
		}, 200);
	},
};
