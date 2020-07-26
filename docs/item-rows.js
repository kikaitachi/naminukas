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

