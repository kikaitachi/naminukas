const createDiv = (className, content) => {
	const element = document.createElement('div');
	element.className = className;
	element.innerHTML = content;
	return element;
};

const createMenu = (text, spaces, radius) => {
	const pathname = window.location.pathname;
	let page = pathname.substring(pathname.lastIndexOf('/') + 1);
	if (page === '' || page === 'index.html') {
		page = 'about.html';
	}
	const words = text.split(' ');
	var deg = 90 / (text.length + (words.length - 1) * (spaces - 1)), origin = -45;
	var content = '';
	words.forEach((word) => {
		content += '<a href="';
		if (word === 'about') {
			content += '/';
		} else {
			content += `${word}.html`
		}
		content += '"';
		if (`${word}.html` === page) {
			content += ' class="selected"';
		}
		content += '>';
		word.split('').forEach((character) => {
			content += `<span style='height:${radius}px;position:absolute;transform:rotate(${origin}deg);transform-origin:0 100%'>${character}</span>`;
			origin += deg;
		});
		content += '</a>';
		origin += deg * spaces;
	});
	return createDiv('menu', content);
};

const header = createDiv('header', '');
header.appendChild(createDiv('title', 'NAMINUKAS'));
header.appendChild(createDiv('description', 'pneumatic wall climbing robot'));
header.appendChild(createMenu('about blog donate faq contact', 2, 250));
document.body.appendChild(header);

const script = document.createElement('script');
script.setAttribute('async', true);
script.setAttribute('src', 'https://www.googletagmanager.com/gtag/js?id=UA-183127-4');
document.getElementsByTagName('head')[0].appendChild(script);

window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());
gtag('config', 'UA-183127-4');

