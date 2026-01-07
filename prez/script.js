/**
 * clAra Mobility Presentation - Navigation System
 */

class Presentation {
    constructor() {
        this.currentSlide = 0;
        this.totalSlides = 6;
        this.slides = [];
        this.isAnimating = false;

        this.init();
    }

    async init() {
        await this.loadSlides();
        this.setupNavigation();
        this.setupKeyboardNavigation();
        this.createIndicators();
        this.showSlide(0);
    }

    async loadSlides() {
        const container = document.getElementById('slidesContainer');
        const slideFiles = [
            'slides/slide1.html',
            'slides/slide2.html',
            'slides/slide3.html',
            'slides/slide4.html',
            'slides/slide5.html',
            'slides/slide6.html'
        ];

        for (let i = 0; i < slideFiles.length; i++) {
            try {
                const response = await fetch(slideFiles[i]);
                const html = await response.text();
                container.insertAdjacentHTML('beforeend', html);
            } catch (error) {
                console.error(`Failed to load ${slideFiles[i]}:`, error);
            }
        }

        this.slides = document.querySelectorAll('.slide');
        document.getElementById('totalSlides').textContent = this.slides.length;
    }

    setupNavigation() {
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');

        prevBtn.addEventListener('click', () => this.prevSlide());
        nextBtn.addEventListener('click', () => this.nextSlide());

        this.updateNavButtons();
    }

    setupKeyboardNavigation() {
        document.addEventListener('keydown', (e) => {
            switch (e.key) {
                case 'ArrowRight':
                case ' ':
                case 'Enter':
                    e.preventDefault();
                    this.nextSlide();
                    break;
                case 'ArrowLeft':
                case 'Backspace':
                    e.preventDefault();
                    this.prevSlide();
                    break;
                case 'Home':
                    e.preventDefault();
                    this.goToSlide(0);
                    break;
                case 'End':
                    e.preventDefault();
                    this.goToSlide(this.totalSlides - 1);
                    break;
            }
        });

        // Touch/swipe support
        let touchStartX = 0;
        let touchEndX = 0;

        document.addEventListener('touchstart', (e) => {
            touchStartX = e.changedTouches[0].screenX;
        });

        document.addEventListener('touchend', (e) => {
            touchEndX = e.changedTouches[0].screenX;
            this.handleSwipe();
        });

        this.handleSwipe = () => {
            const swipeThreshold = 50;
            const diff = touchStartX - touchEndX;

            if (Math.abs(diff) > swipeThreshold) {
                if (diff > 0) {
                    this.nextSlide();
                } else {
                    this.prevSlide();
                }
            }
        };
    }

    createIndicators() {
        const indicatorsContainer = document.getElementById('slideIndicators');
        indicatorsContainer.innerHTML = '';

        for (let i = 0; i < this.totalSlides; i++) {
            const indicator = document.createElement('div');
            indicator.className = 'indicator';
            indicator.addEventListener('click', () => this.goToSlide(i));
            indicatorsContainer.appendChild(indicator);
        }

        this.updateIndicators();
    }

    updateIndicators() {
        const indicators = document.querySelectorAll('.indicator');
        indicators.forEach((indicator, index) => {
            indicator.classList.toggle('active', index === this.currentSlide);
        });
    }

    updateNavButtons() {
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');

        prevBtn.disabled = this.currentSlide === 0;
        nextBtn.disabled = this.currentSlide === this.totalSlides - 1;
    }

    showSlide(index) {
        if (this.isAnimating || index < 0 || index >= this.slides.length) return;

        this.isAnimating = true;
        const previousSlide = this.currentSlide;
        this.currentSlide = index;

        this.slides.forEach((slide, i) => {
            slide.classList.remove('active', 'prev');

            if (i === index) {
                slide.classList.add('active');
            } else if (i < index) {
                slide.classList.add('prev');
            }
        });

        document.getElementById('currentSlide').textContent = this.currentSlide + 1;
        this.updateIndicators();
        this.updateNavButtons();

        // Reset animation state after transition
        setTimeout(() => {
            this.isAnimating = false;
        }, 600);
    }

    nextSlide() {
        if (this.currentSlide < this.totalSlides - 1) {
            this.goToSlide(this.currentSlide + 1);
        }
    }

    prevSlide() {
        if (this.currentSlide > 0) {
            this.goToSlide(this.currentSlide - 1);
        }
    }

    goToSlide(index) {
        if (index >= 0 && index < this.totalSlides && index !== this.currentSlide) {
            this.showSlide(index);
        }
    }
}

// Initialize presentation when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    new Presentation();
});
