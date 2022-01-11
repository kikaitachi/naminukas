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

const STLViewer = (model, elementID) => {
  const elem = document.getElementById(elementID);

  const camera = new THREE.PerspectiveCamera(70, elem.clientWidth / elem.clientHeight, 1, 1000);

  var renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
  renderer.setSize(elem.clientWidth, elem.clientHeight);
  elem.appendChild(renderer.domElement);

  window.addEventListener('resize', function () {
    renderer.setSize(elem.clientWidth, elem.clientHeight);
    camera.aspect = elem.clientWidth/elem.clientHeight;
    camera.updateProjectionMatrix();
  }, false);

  const controls = new THREE.OrbitControls(camera, renderer.domElement);
  controls.enableDamping = true;
  controls.rotateSpeed = 0.05;
  controls.dampingFactor = 0.1;
  controls.enableZoom = true;
  controls.autoRotate = true;
  controls.autoRotateSpeed = .75;

  const scene = new THREE.Scene();
  scene.add(new THREE.HemisphereLight(0xffffff, 1.5));

  (new THREE.STLLoader()).load(model, function (geometry) {
    const material = new THREE.MeshPhongMaterial({
        color: 0xff5533,
        specular: 100,
        shininess: 100 });
    const mesh = new THREE.Mesh(geometry, material);
    scene.add(mesh);
    const middle = new THREE.Vector3();
    geometry.computeBoundingBox();
    geometry.boundingBox.getCenter(middle);
    mesh.geometry.applyMatrix4(new THREE.Matrix4().makeTranslation(-middle.x, -middle.y, -middle.z ) );
    const largestDimension = Math.max(geometry.boundingBox.max.x,
                                    geometry.boundingBox.max.y,
                                    geometry.boundingBox.max.z);
    camera.position.z = largestDimension * 2.5;
    const animate = () => {
      requestAnimationFrame(animate);
      controls.update();
      renderer.render(scene, camera);
    };
    animate();
  });
}

const renderBom = (bom) => {
  const contentEl = document.getElementById('itemsToBuy');
  let content = "";
  let sum = 0;
  for (const item of bom) {
    if (item.buyUrl) {
      content += `<a href="${item.buyUrl}" target="_blank">`;
      content += `<img src="${item.imageUrl}" alt="${item.name + ' ' + item.description}">`;
      content += `<span>${item.name}</span>`;
      content += `<span>${item.description}</span>`;
      content += `<span>${item.quantity} × ${item.price} ${item.currency}</span></a>`;
      sum += item.quantity * item.price;
    }
  }
  contentEl.innerHTML = content;
  document.getElementById('partsToBuyTitle').innerHTML += ` (estimated cost: ${sum.toFixed(2)} GBP)`;
}

const showParts = () => {
  fetch("/bom.json")
    .then(response => response.json())
    .then(bom => renderBom(bom));
  STLViewer('models/power_and_control_bracket.stl', 'model');
}
