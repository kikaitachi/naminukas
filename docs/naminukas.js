const createDiv = (className, content) => {
	const element = document.createElement('div');
	element.className = className;
	element.innerHTML = content;
	return element;
};

const createMenu = (text, spaces) => {
	const pathname = window.location.pathname;
	let page = pathname.substring(pathname.lastIndexOf('/') + 1);
	if (page === '' || page === 'index.html') {
		page = 'about';
	} else if (window.location.pathname.includes('blog')) {
		page = 'blog';
	}
	const words = text.split(' ');
	var deg = 100 / (text.length + (words.length - 1) * (spaces - 1)), origin = -50;
	var content = '';
	words.forEach((word) => {
		content += '<a href="/';
		if (word !== 'about') {
			content += word;
		}
		content += '"';
		if (word === page) {
			content += ' class="selected"';
		}
		content += '>';
		word.split('').forEach((character) => {
			content += `<span style='transform:rotate(${origin}deg)'>${character}</span>`;
			origin += deg;
		});
		content += '</a>';
		origin += deg * spaces;
	});
	const element = document.createElement('nav');
	element.className = 'menu';
	element.innerHTML = content;
	return element;
};

const header = createDiv('header', '');
header.appendChild(createDiv('title', 'NAMINUKAS'));
header.appendChild(createDiv('description', 'walking, driving and wall climbing robot'));
header.appendChild(createMenu('about blog donate faq contact', 2));
document.body.appendChild(header);

const head = document.getElementsByTagName('head')[0];

const styleLink = document.createElement('link');
styleLink.setAttribute('rel', 'stylesheet');
styleLink.setAttribute('type', 'text/css');
styleLink.setAttribute('href', '/naminukas.css');
head.appendChild(styleLink);

const iconLink = document.createElement('link');
iconLink.setAttribute('rel', 'shortcut icon');
iconLink.setAttribute('type', 'image/png');
iconLink.setAttribute('href', '/images/logo.png');
head.appendChild(iconLink);

const script = document.createElement('script');
script.setAttribute('async', true);
script.setAttribute('src', 'https://www.googletagmanager.com/gtag/js?id=UA-183127-4');
head.appendChild(script);

window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());
gtag('config', 'UA-183127-4');
