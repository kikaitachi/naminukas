const head = document.getElementsByTagName('head')[0];

const iconLink = document.createElement('link');
iconLink.setAttribute('rel', 'shortcut icon');
iconLink.setAttribute('type', 'image/png');
iconLink.setAttribute('href', '/images/logo.png');
head.appendChild(iconLink);

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
	} else if (pathname.includes('blog')) {
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
			content += `<span style='transform:translate(-50%, 0) rotate(${origin}deg)'>${character}</span>`;
			origin += deg;
		});
		content += '</a>';
		origin += deg * spaces;
	});
	return createEl('nav', 'menu', content);
};

const header = createEl('div', 'header', '');
header.appendChild(createEl('div', 'title', 'NAMINUKAS'));
header.appendChild(createEl('div', 'description', 'walking, driving, wall climbing & tool using robot'));
header.appendChild(createMenu('about roadmap blog build donate', 2));
document.body.appendChild(header);

const footer = createEl('div', 'footer', '');
footer.appendChild(createSocialMediaLink('youtube.svg', 'https://www.youtube.com/KIKAItachi', 'YouTube'));
footer.appendChild(createSocialMediaLink('hackaday.png', 'https://hackaday.io/project/170788-naminukas', 'Hackaday'));
footer.appendChild(createSocialMediaLink('patreon.png', 'https://www.patreon.com/KIKAItachi', 'Patreon'));
footer.appendChild(createSocialMediaLink('github.svg', 'https://github.com/kikaitachi/naminukas', 'GitHub'));
footer.appendChild(createSocialMediaLink('twitter.svg', 'https://twitter.com/KIKAItachi', 'Twitter'));
document.body.appendChild(footer);

const irResize = (container) => {
	const margin = 20;
	const maxLineLength = container.clientWidth - margin;
	let lineImages = [];
	let margins = [];
	let lineLength = 0;
	let totalLines = 0;
	const lineHeight = 150;
	const items = container.querySelectorAll('.item');
	for (let i = 0; i < items.length; i++) {
		const img = items[i].querySelector('img');
		const width = img.naturalWidth * lineHeight / img.naturalHeight + margin;
		if (lineImages.length > 0 && lineLength + width >= maxLineLength) {
			// Resize images
			const scale = (maxLineLength - margin * lineImages.length) / (lineLength - margin * lineImages.length);
			const newHeight = Math.floor(lineHeight * scale);
			lineLength = 0;
			for (let j = 0; j < lineImages.length; j++) {
				const newWidth = Math.round(lineImages[j].naturalWidth * newHeight / lineImages[j].naturalHeight);
				lineImages[j].style.width = newWidth + 'px';
				lineImages[j].style.height = newHeight + 'px';
				lineImages[j].parentNode.style.display = 'inline-block';
				lineLength += margin + newWidth;
			}

			// Adjust margins
			if (lineImages.length > 1) {
				outer: while (lineLength < maxLineLength) {
					for (let j = lineImages.length - 1; j > 0; j--) {
						margins[j]++;
						lineLength++;
						lineImages[j].parentNode.style.marginLeft = margins[j] + 'px';
						if (lineLength >= maxLineLength) {
							break outer;
						}
					}
				}
			}

			// Reset to new line
			lineImages = [];
			margins = [];
			lineLength = 0;
			totalLines++;
		}
		lineLength += width;
		lineImages.push(img);
		margins.push(margin);
	}
	lineImages.forEach(img => {
		img.style.height = lineHeight + 'px';
		img.parentNode.style.display = 'inline-block';
	});
};

const irAdd = (container, name, imageUrl, alt, link) => {
	return new Promise((resolve, reject) => {
		const image = new Image();
		image.onload = () => {
			const info = document.createElement('div');
			info.className = 'itemInfo';
			info.innerHTML = name;

			const item = document.createElement('a');
			item.className = 'item';
			item.target = '_blank';
			item.href = link;
			item.appendChild(image);
			item.appendChild(info);

			container.appendChild(item);
			irResize(container);

			resolve();
		};
		image.onerror = reject;
		image.src = imageUrl;
		image.className = 'itemImage';
		image.alt = alt;
	});
};
