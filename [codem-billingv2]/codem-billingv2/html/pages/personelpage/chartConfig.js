export const getChartConfig = (data, locales) => {
	return {
		type: 'line',
		data: {
			labels: locales,
			datasets: [
				{
					label: '$',
					data: data.incoming,
					borderWidth: 5,
					barThickness: 10,
					borderColor: '#548DE8',
					tension: 0.1,
				},
				{
					label: '$',
					data: data.outgoing,
					borderWidth: 5,
					barThickness: 10,
					borderColor: '#E85454',
					tension: 0.1,
				},
			],
		},
		options: {
			hoverRadius: 12,
			hoverBackgroundColor: 'white',
			responsive: true,
			interaction: {
				mode: 'nearest',
				intersect: false,
			},
			maintainAspectRatio: false,
			plugins: {
				legend: { display: false },
				tooltip: {
					backgroundColor: '#548DE8',
					titleColor: '#ffffff',
					bodyColor: '#ffffff',
					padding: 10,
					displayColors: false,
					cornerRadius: 8,
					callbacks: {
						label: function (tooltipItem) {
							return `${Number(tooltipItem.raw).toLocaleString()}$`;
						},
					},
				},
			},
			scales: {
				y: {
					beginAtZero: true,
					ticks: {
						color: 'white',
						callback: function (value) {
							return Number(value).toLocaleString() + '$';
						},
						font: {
							family: 'Gilroy-Bold',
							size: 15,
						},
					},
				},
				x: {
					ticks: {
						color: 'white',
						font: {
							family: 'Gilroy-Semibold',
							size: 15,
						},
					},
				},
			},
		},
	};
};
