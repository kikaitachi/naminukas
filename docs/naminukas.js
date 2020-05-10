const createEl = (elementName, className, content) => {
	const element = document.createElement(elementName);
	element.className = className;
	element.innerHTML = content;
	return element;
};

const createSocialMediaLink = (icon, link, text) => {
	const element = document.createElement('a');
	element.href = link;
	element.innerHTML = `<img src="/images/${icon}" style="height: 2rem"/><span>${text}</span>`;
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
	const deg = 40 / (text.length + (words.length - 1) * (spaces - 1));
	let origin = -20;
	let content = '';
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
	return createEl('nav', 'menu', content);
};

const header = createEl('div', 'header', '');
header.appendChild(createEl('div', 'title', 'NAMINUKAS'));
header.appendChild(createEl('div', 'description', 'walking, driving and wall climbing robot'));
header.appendChild(createMenu('about blog donate build faq', 2));
document.body.appendChild(header);

const footer = createEl('div', 'footer', '');
footer.appendChild(createSocialMediaLink('youtube.svg', 'https://www.youtube.com/channel/UCt_dgg2b43NzLccvOelkCAw', 'YouTube'));
footer.appendChild(createSocialMediaLink('hackaday.png', 'https://hackaday.io/project/170788-naminukas', 'Hackaday'));
footer.appendChild(createSocialMediaLink('patreon.png', 'https://www.patreon.com/KIKAItachi', 'Patreon'));
footer.appendChild(createSocialMediaLink('github.svg', 'https://github.com/kikaitachi/naminukas', 'GitHub'));
footer.appendChild(createSocialMediaLink('email.png', 'mailto:naminukas@kikaitachi.com', 'Email'));
document.body.appendChild(footer);

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
