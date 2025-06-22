export class NotificationManager {
	constructor() {
		this.store = null;
		this.notifications = {
			tablet: [],
			normal: [],
		};
	}

	setStore(store) {
		this.store = store;
	}

	clearExpiredNotifications(type) {
		if (!this.store) return;

		const notifications = this.notifications[type];
		const expiredNotifications = notifications.filter((n) => n.removed);

		expiredNotifications.forEach((notification) => {
			if (notification.timeout) {
				clearTimeout(notification.timeout);
			}
		});

		this.notifications[type] = notifications.filter((n) => !n.removed);

		if (type === 'tablet') {
			this.store.state.TabletNotifications = this.store.state.TabletNotifications.filter((n) => !n.removed);
		} else {
			this.store.state.NormalNotifications = this.store.state.NormalNotifications.filter((n) => !n.removed);
		}
	}

	addNotification(type, data) {
		if (!this.store) return null;

		const { message = 'unknown message', timeout = 5000, header = 'Notification', type: notificationType = 'info' } = data;

		// Check if there's an existing notification with the same text
		const existingNotification = this.notifications[type].find((n) => n.text === message);
		if (existingNotification) {
			return existingNotification; // Return existing notification instead of creating a new one
		}

		this.notifications[type].forEach((notification) => {
			if (notification.timeout) {
				clearTimeout(notification.timeout);
			}
		});
		this.notifications[type] = [];

		if (type === 'tablet') {
			this.store.state.TabletNotifications = [];
		} else {
			this.store.state.NormalNotifications = [];
		}

		const notification = {
			id: Date.now(),
			text: message,
			header,
			type: notificationType,
			time: new Date(),
			timeout: null,
			removed: false,
		};

		notification.timeout = setTimeout(() => {
			if (type === 'tablet') {
				const index = this.store.state.TabletNotifications.findIndex((n) => n.id === notification.id);
				if (index !== -1) {
					this.store.state.TabletNotifications.splice(index, 1);
				}
			} else {
				const index = this.store.state.NormalNotifications.findIndex((n) => n.id === notification.id);
				if (index !== -1) {
					this.store.state.NormalNotifications.splice(index, 1);
				}
			}

			const localIndex = this.notifications[type].findIndex((n) => n.id === notification.id);
			if (localIndex !== -1) {
				this.notifications[type].splice(localIndex, 1);
			}
		}, timeout);

		this.notifications[type].push(notification);

		if (type === 'tablet') {
			this.store.state.TabletNotifications.push({ ...notification });
		} else {
			this.store.state.NormalNotifications.push({ ...notification });
		}

		return notification;
	}

	showTabletNotification(data) {
		return this.addNotification('tablet', data);
	}

	showNormalNotification(data) {
		return this.addNotification('normal', data);
	}

	removeNotification(type, id) {
		const notification = this.notifications[type].find((n) => n.id === id);
		if (notification) {
			if (notification.timeout) {
				clearTimeout(notification.timeout);
			}

			const localIndex = this.notifications[type].findIndex((n) => n.id === id);
			if (localIndex !== -1) {
				this.notifications[type].splice(localIndex, 1);
			}

			if (type === 'tablet') {
				const index = this.store.state.TabletNotifications.findIndex((n) => n.id === id);
				if (index !== -1) {
					this.store.state.TabletNotifications.splice(index, 1);
				}
			} else {
				const index = this.store.state.NormalNotifications.findIndex((n) => n.id === id);
				if (index !== -1) {
					this.store.state.NormalNotifications.splice(index, 1);
				}
			}
		}
	}

	destroy() {
		Object.values(this.notifications).forEach((notificationList) => {
			notificationList.forEach((notification) => {
				if (notification.timeout) {
					clearTimeout(notification.timeout);
				}
			});
		});

		if (this.store) {
			this.store.state.TabletNotifications = [];
			this.store.state.NormalNotifications = [];
		}

		this.notifications = {
			tablet: [],
			normal: [],
		};
	}
}
