export class EventHandlerManager {
	constructor(store, app) {
		this.store = store;
		this.app = app;
	}

	handleEvent(event) {
		try {
			const methodName = `handle${event.data.action}`;
			if (typeof this[methodName] === 'function') {
				this[methodName](event.data.payload);
			}
		} catch (error) {
			console.error('Event handling error:', error);
		}
	}

	handleCHECK_NUI() {
		postNUI('LoadedNUI');
	}
	handleSET_LOCALE(payload) {
		this.store.state.Locales = payload;
	}

	handleUPDATE_JOB_PLAYER(payload) {
		if (this.store.state.PlayerData) {
			this.store.state.PlayerData.job = payload;
		}
	}

	handleOPEN_APPROVAL_MENU() {
		this.app.ApprovalMenu = true;
		const sourceCanvas = document.querySelector('#backgroundCanvas');
		if (sourceCanvas) {
			sourceCanvas.style.display = 'block';
			this.app.createGameView(sourceCanvas);
		}
	}

	handleOPEN_BILLING_MENU() {
		const sourceCanvas = document.querySelector('#backgroundCanvas');
		if (sourceCanvas) {
			sourceCanvas.style.display = 'block';
			this.app.createGameView(sourceCanvas);
		}
		this.store.state.activePage = 'personelpage';
		this.app.OpenBillingMenu = true;
		this.store.dispatch('SetShowNavbar', true);
	}

	handleLOAD_INFO(payload) {
		this.store.state.PlayerData = payload;
	}

	handlePAY_PERSONEL_BILLING(payload) {
		let MyAllBills = this.store.state.PlayerData.billing;
		let invoiceID = payload;
		if (MyAllBills[invoiceID]) {
			this.store.state.PlayerData.billing[invoiceID].status = 'paid';
			if (this.app.ShowBillingModal) {
				this.app.NewBilling = false;
				this.app.PaidedBilling = this.store.state.PlayerData.billing[invoiceID];
				setTimeout(() => {
					this.app.PaidedBilling = false;
					postNUI('CloseBillingMenu');
					this.app.ShowBillingModal = false;
				}, 5000);
			}
		}
	}

	handleCANCEL_AWAITING_BILL(payload) {
		let MyAllBilling = this.store.state.PlayerData.billing;
		let invoiceid = payload;
		if (MyAllBilling[invoiceid]) {
			delete this.store.state.PlayerData.billing[invoiceid];
		}
	}

	handleAPPLY_FOR_BILLING_PLAYER(payload) {
		this.app.ApplyForBillingPlayer = payload;
	}

	handleLOAD_ALL_APPROVAL(payload) {
		this.store.state.ApplicationsData = payload;
	}

	handleINSERT_APPROVAL_DATA(payload) {
		if (this.store.state.ApplicationsData.length <= 0) {
			this.store.state.ApplicationsData = {};
		}
		this.store.state.ApplicationsData[payload.identifier] = payload.data;
	}

	handleDELETE_APPROVAL_DATA(payload) {
		if (this.store.state.ApplicationsData[payload]) {
			delete this.store.state.ApplicationsData[payload];
		}
	}

	handleNEW_BILLING(payload) {
		if (this.app.OpenBillingMenu) return;
		this.app.ShowBillingModal = true;
		this.app.NewBilling = payload;
	}

	handleCLOSE_BILLING_MODAL() {
		this.app.ShowBillingModal = false;
		this.app.NewBilling = false;
		if (!this.app.OpenBillingMenu) {
			postNUI('CLOSE_CURSOR');
		}
	}

	handleINSERT_BILLING(payload) {
		if (this.store.state.PlayerData.billing) {
			if (Object.values(this.store.state.PlayerData.billing).length <= 0) {
				this.store.state.PlayerData.billing = {};
			}
			this.store.state.PlayerData.billing[payload.billingid] = payload.template;
		}
	}

	handleUPDATE_SPEND_DATA(payload) {
		if (this.store.state.PlayerData.spenddata) {
			if (this.store.state.PlayerData.spenddata[payload.type]) {
				this.store.state.PlayerData.spenddata[payload.type][payload.day] += payload.amount;
				this.store.state.UpdateSpend = true;
				setTimeout(() => {
					this.store.state.UpdateSpend = false;
				}, 1000);
			}
		}
	}

	handleUPDATE_JOB_SPEND_DATA(payload) {
		if (this.store.state.JobsData && this.store.state.JobsData.jobname === payload.jobname) {
			if (this.store.state.JobsData.spenddata?.[payload.type]) {
				this.store.state.JobsData.spenddata[payload.type][payload.day] += payload.amount;
				this.store.state.UpdateJobSpend = true;
				setTimeout(() => {
					this.store.state.UpdateJobSpend = false;
				}, 1000);
			}
		}
	}

	handleLOAD_JOB_DATA(payload) {
		this.store.state.JobsData = payload;
	}

	handleUPDATE_VAULT(payload) {
		if (this.store.state.JobsData && this.store.state.JobsData.jobname === payload.jobname) {
			this.store.state.JobsData.vault = payload.newvault;
		}
	}

	handleUPDATE_LOG(payload) {
		if (this.store.state.JobsData && this.store.state.JobsData.jobname === payload.jobname) {
			if (!this.store.state.JobsData.log.length) {
				this.store.state.JobsData.log = [];
			}
			this.store.state.JobsData.log.push(payload.log);
		}
	}

	handleDELETE_TEMPLATE(payload) {
		if (this.store.state.JobsData) {
			this.store.state.JobsData.template = this.store.state.JobsData.template.filter((item) => item.uniqueid !== payload);
		}
	}

	handleNOTIFICATION(payload) {
		const notificationType = this.app.OpenBillingMenu || this.app.ApprovalMenu ? 'TabletNotification' : 'NormalNotification';

		this.store.dispatch(notificationType, {
			message: payload.message,
			type: payload.type,
			timeout: 5000,
			header: payload.type,
		});
	}

	handleINSERT_JOB_BILLING(payload) {
		let JobName = payload.jobname;
		let BillingID = payload.billingid;
		let BillingData = payload.template;

		if (this.store.state.JobsData && this.store.state.JobsData.jobname == JobName) {
			if (Object.values(this.store.state.JobsData.billing).length <= 0) {
				this.store.state.JobsData.billing = {};
			}
			this.store.state.JobsData.billing[BillingID] = BillingData;
		}
	}

	handleCANCEL_JOB_AWAITING_BILL(payload) {
		let JobName2 = payload.jobname;
		let BillingID2 = payload.invoiceid;
		if (this.store.state.JobsData && this.store.state.JobsData.jobname == JobName2) {
			if (this.store.state.JobsData.billing[BillingID2]) {
				delete this.store.state.JobsData.billing[BillingID2];
			}
		}
	}

	handlePAY_JOB_BILLING(payload) {
		let JobName3 = payload.jobname;
		let BillingID3 = payload.billingid;
		if (this.store.state.JobsData && this.store.state.JobsData.jobname == JobName3) {
			if (this.store.state.JobsData.billing[BillingID3]) {
				this.store.state.JobsData.billing[BillingID3].status = 'paid';
			}
		}
	}

	handleNEW_TEMPLATE(payload) {
		let JobName4 = payload.jobname;
		let TemplateData = payload.template;
		if (this.store.state.JobsData && this.store.state.JobsData.jobname == JobName4) {
			if (this.store.state.JobsData.template.length <= 0) {
				this.store.state.JobsData.template = [];
			}
			this.store.state.JobsData.template.push(TemplateData);
		}
	}

	handleUPDATE_TEMPLATE_REASON(payload) {
		let JobName4 = payload.jobname;
		let TemplateData = payload.template;
		let Uniqueid = payload.uniqueid;
		if (this.store.state.JobsData && this.store.state.JobsData.jobname == JobName4) {
			this.store.state.JobsData.template.forEach((template) => {
				if (template.uniqueid === Uniqueid) {
					template.template.push(TemplateData);
				}
			});
		}
	}

	handleUPDATE_TEMPLATE(payload) {
		let JobName5 = payload.jobname;
		let Uniqueid = payload.uniqueid;
		let Reasonid = payload.reasonid;

		if (this.store.state.JobsData && this.store.state.JobsData.jobname === JobName5) {
			this.store.state.JobsData.template.forEach((template) => {
				if (template.uniqueid === Uniqueid) {
					template.template = template.template.filter((item) => item.id !== Reasonid);
				}
			});
		}
	}

	handleUPDATE_LOGO(payload) {
		let JobName6 = payload.jobname;
		let Logo = payload.logo;
		if (this.store.state.JobsData && this.store.state.JobsData.jobname == JobName6) {
			this.store.state.JobsData.logo = Logo;
		}
	}

	handleREMOVE_EMPLOYESS(payload) {
		let JobName7 = payload.jobname;
		let Identifier = payload.identifier;

		if (this.store.state.JobsData && this.store.state.JobsData.jobname == JobName7) {
			if (this.store.state.JobsData.personels[Identifier]) {
				delete this.store.state.JobsData.personels[Identifier];
			}
		}
	}

	handleADD_EMPLOYESS(payload) {
		let JobName8 = payload.jobname;
		let Identifier2 = payload.identifier;
		let PlayerData = payload.tempdata;
		if (this.store.state.JobsData && this.store.state.JobsData.jobname == JobName8) {
			if (Object.values(this.store.state.JobsData.personels).length <= 0) {
				this.store.state.JobsData.personels = {};
			}
			if (!this.store.state.JobsData.personels[Identifier2]) {
				this.store.state.JobsData.personels[Identifier2] = {};
			}
			this.store.state.JobsData.personels[Identifier2] = PlayerData;
		}
	}

	handleWAITING_FOR_JOB_DATA(payload) {
		this.app.waitingForJobData = payload;
		if (payload) {
			this.app.ApprovalMenuData.page = 'page3';
		} else {
			this.app.ApprovalMenuData.page = 'page1';
		}
	}

	handleUPDATE_MONEY(payload) {
		if (this.store.state.PlayerData) {
			this.store.state.PlayerData.bank = payload;
		}
	}

	handleSET_OVERDUEDATE(payload) {
		this.store.state.OverDueDate = payload;
	}

	handleLOAD_ALL_ADMIN_DATA(payload) {
		this.store.state.AdminData = payload;
	}

	handleINSERT_ADMIN_LOG(payload) {
		if (this.store.state.AdminData && this.store.state.AdminData.AllLogs) {
			this.store.state.AdminData.AllLogs.push(payload);
		}
	}

	handleCANCEL_ADMIN_AWAITING_BILL(payload) {
		let uniqueid = payload;
		if (this.store.state.AdminData && this.store.state.AdminData.AllBilling) {
			if (this.store.state.AdminData.AllBilling[uniqueid]) {
				delete this.store.state.AdminData.AllBilling[uniqueid];
			}
		}
	}

	handleINSERT_ADMIN_BILLING(payload) {
		let uniqueid = payload.billingid;
		let billingdata = payload.template;

		if (this.store.state.AdminData && this.store.state.AdminData.AllBilling) {
			if (Object.values(this.store.state.AdminData.AllBilling).length <= 0) {
				this.store.state.AdminData.AllBilling = {};
			}

			if (!this.store.state.AdminData.AllBilling[uniqueid]) {
				this.store.state.AdminData.AllBilling[uniqueid] = {};
			}
			this.store.state.AdminData.AllBilling[uniqueid] = billingdata;
		}
	}

	handleUPDATE_BILL_STATUS_ADMIN(payload) {
		let uniqueid = payload;
		if (this.store.state.AdminData && this.store.state.AdminData.AllBilling) {
			if (this.store.state.AdminData.AllBilling[uniqueid]) {
				this.store.state.AdminData.AllBilling[uniqueid].status = 'paid';
			}
		}
	}

	handleINSERT_AUTHORIZED(payload) {
		let identifier = payload.identifier;
		let autdata = payload.autdata;
		if (this.store.state.AdminData && this.store.state.AdminData.AllAuthorized) {
			if (Object.values(this.store.state.AdminData.AllAuthorized).length <= 0) {
				this.store.state.AdminData.AllAuthorized = {};
			}

			if (!this.store.state.AdminData.AllAuthorized[identifier]) {
				this.store.state.AdminData.AllAuthorized[identifier] = {};
			}
			this.store.state.AdminData.AllAuthorized[identifier].autdata = autdata;
		}
	}

	handleDELETE_AUTHORIZED(payload) {
		let identifier = payload;
		if (this.store.state.AdminData && this.store.state.AdminData.AllAuthorized) {
			delete this.store.state.AdminData.AllAuthorized[identifier];
		}
	}

	handleUPDATE_CREATE_BILLING(payload) {
		if (this.store.state.PlayerData) {
			this.store.state.PlayerData.createbilling = payload;
		}
	}

	handleLOAD_ALL_SERVER_TAXES(payload) {
		this.store.state.ServerTaxes = payload;
	}

	handleCHANGE_TAX_ACTIVE(payload) {
		let uniqueid = payload.uniqueid;
		let active = payload.active;
		if (this.store.state.ServerTaxes && this.store.state.ServerTaxes[uniqueid]) {
			this.store.state.ServerTaxes[uniqueid].active = active;
		}
	}

	handleUPDATE_EDITING_PAGE(payload) {
		let uniqueid = payload.uniqueid;

		if (this.store.state.ServerTaxes && this.store.state.ServerTaxes[uniqueid]) {
			this.store.state.ServerTaxes[uniqueid] = payload;
		}
	}

	handleNEW_TAXES(payload) {
		let uniqueid = payload.uniqueid;
		let template = payload.template;

		this.store.state.ServerTaxes[uniqueid] = template;
		this.store.state.UpdateTaxes = true;
		setTimeout(() => {
			this.store.state.UpdateTaxes = false;
		}, 1000);
	}

	handleDELETE_TAXES(payload) {
		let uniqueid = payload;
		if (this.store.state.ServerTaxes && this.store.state.ServerTaxes[uniqueid]) {
			delete this.store.state.ServerTaxes[uniqueid];

			setTimeout(() => {
				this.store.state.UpdateTaxes = true;
			}, 1000);
			setTimeout(() => {
				this.store.state.UpdateTaxes = false;
			}, 2000);
		}
	}

	handleUPDATE_PERMISSION(payload) {
		let jobname = payload.jobname;
		let identifier = payload.identifier;
		let permission = payload.permission;

		if (this.store.state.JobsData && this.store.state.JobsData.jobname === jobname) {
			if (this.store.state.JobsData.personels[identifier]) {
				this.store.state.JobsData.personels[identifier].permission = permission;
			}
		}
	}

	handleUPDATE_VAULT(payload) {
		let jobname = payload.jobname;
		let vault = payload.newvault;

		if (this.store.state.JobsData && this.store.state.JobsData.jobname === jobname) {
			this.store.state.JobsData.vault = vault;
		}
	}

	handleUPDATE_SPEND_DATA_ADMIN(payload) {
		let day = payload.day;
		let amount = payload.amount;

		if (this.store.state.AdminData && this.store.state.AdminData.SpendData) {
			this.store.state.AdminData.SpendData[day] += amount;
			setTimeout(() => {
				this.store.state.UpdateAdminSpend = true;
			}, 1000);
			setTimeout(() => {
				this.store.state.UpdateAdminSpend = false;
			}, 2000);
		}
	}

	handleSET_CONFIG_TAX(payload) {
		this.store.state.BillingTax = payload;
	}
}
