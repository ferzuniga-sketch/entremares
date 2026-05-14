/* =========================================
   ENTREMARES — Main JavaScript
   ========================================= */

(function () {
    'use strict';

    /* ===== Nav scroll effect ===== */
    const nav = document.getElementById('nav');

    function updateNav() {
        if (!nav) return;
        if (window.scrollY > 48) {
            nav.classList.add('scrolled');
        } else {
            nav.classList.remove('scrolled');
        }
    }

    window.addEventListener('scroll', updateNav, { passive: true });
    updateNav();

    /* ===== Mobile menu ===== */
    const toggle   = document.getElementById('navToggle');
    const mobileMenu = document.getElementById('mobileMenu');

    if (toggle && mobileMenu) {
        toggle.addEventListener('click', () => {
            const isOpen = mobileMenu.classList.contains('open');
            mobileMenu.classList.toggle('open', !isOpen);
            toggle.classList.toggle('active', !isOpen);
            toggle.setAttribute('aria-expanded', String(!isOpen));
        });

        mobileMenu.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', () => {
                mobileMenu.classList.remove('open');
                toggle.classList.remove('active');
                toggle.setAttribute('aria-expanded', 'false');
            });
        });

        document.addEventListener('click', (e) => {
            if (!nav.contains(e.target) && !mobileMenu.contains(e.target)) {
                mobileMenu.classList.remove('open');
                toggle.classList.remove('active');
            }
        });
    }

    /* ===== Hero image entrance ===== */
    const hero    = document.getElementById('hero');
    const heroImg = hero?.querySelector('.hero-img');

    if (heroImg) {
        const markLoaded = () => hero.classList.add('loaded');
        if (heroImg.complete) {
            markLoaded();
        } else {
            heroImg.addEventListener('load', markLoaded);
            heroImg.addEventListener('error', markLoaded);
        }
    }

    /* ===== Scroll-triggered fade-up animations ===== */
    const fadeEls = document.querySelectorAll('.fade-up');

    if ('IntersectionObserver' in window && fadeEls.length) {
        const io = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('in-view');
                    io.unobserve(entry.target);
                }
            });
        }, { threshold: 0.12, rootMargin: '0px 0px -32px 0px' });

        fadeEls.forEach(el => io.observe(el));
    } else {
        fadeEls.forEach(el => el.classList.add('in-view'));
    }

    /* ===== Smooth scroll for in-page anchors ===== */
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const id = this.getAttribute('href');
            if (id === '#') return;
            const target = document.querySelector(id);
            if (!target) return;
            e.preventDefault();
            const offset = (nav?.offsetHeight || 72) + 12;
            const top = target.getBoundingClientRect().top + window.scrollY - offset;
            window.scrollTo({ top, behavior: 'smooth' });
        });
    });

    /* ===== Staggered delay for grouped fade-up elements ===== */
    document.querySelectorAll('[data-stagger]').forEach(parent => {
        const children = parent.querySelectorAll('.fade-up');
        children.forEach((child, i) => {
            child.style.transitionDelay = `${i * 100}ms`;
        });
    });

    /* ===== Form handling (apply.html) ===== */
    const applyForm = document.getElementById('applyForm');

    if (applyForm) {
        applyForm.addEventListener('submit', async function (e) {
            e.preventDefault();

            const btn      = applyForm.querySelector('.form-submit');
            const feedback = document.getElementById('formFeedback');

            if (btn.disabled) return;

            btn.disabled = true;
            btn.textContent = 'Sending…';

            const lockForm = () => {
                applyForm.querySelectorAll('.form-input, .form-select, .form-textarea').forEach(el => {
                    el.disabled = true;
                    el.style.opacity = '0.5';
                });
            };

            const showSuccess = () => {
                btn.textContent = 'Application Sent';
                btn.classList.add('success');
                if (feedback) {
                    feedback.textContent = "Thank you! Your application has been received. We’ll be in touch within 2–3 business days.";
                    feedback.className = 'form-feedback success';
                }
                lockForm();
            };

            if (window.emailjs) {
                // TODO: Replace with real EmailJS service_id, template_id and public_key
                try {
                    await emailjs.sendForm('YOUR_SERVICE_ID', 'YOUR_TEMPLATE_ID', applyForm);
                    showSuccess();
                } catch (err) {
                    btn.disabled = false;
                    btn.textContent = 'Submit Application';
                    if (feedback) {
                        feedback.textContent = 'Something went wrong. Please email us directly at ferzuniga@gmail.com';
                        feedback.className = 'form-feedback error';
                    }
                }
            } else {
                setTimeout(showSuccess, 1400);
            }
        });
    }

    /* ===== Stat counters ===== */
    const statEls = document.querySelectorAll('[data-count]');

    if (statEls.length) {
        const counterIO = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (!entry.isIntersecting) return;

                const el       = entry.target;
                const end      = parseFloat(el.dataset.count);
                const prefix   = el.dataset.prefix  || '';
                const suffix   = el.dataset.suffix  || '';
                const decimals = el.dataset.decimals ? parseInt(el.dataset.decimals) : 0;
                const duration = 1600;
                let start      = null;

                function tick(ts) {
                    if (!start) start = ts;
                    const progress = Math.min((ts - start) / duration, 1);
                    const ease     = 1 - Math.pow(1 - progress, 3);
                    const value    = end * ease;
                    el.textContent = prefix + (decimals ? value.toFixed(decimals) : Math.floor(value)) + suffix;
                    if (progress < 1) requestAnimationFrame(tick);
                    else el.textContent = prefix + (decimals ? end.toFixed(decimals) : end) + suffix;
                }

                requestAnimationFrame(tick);
                counterIO.unobserve(el);
            });
        }, { threshold: 0.5 });

        statEls.forEach(el => counterIO.observe(el));
    }

})();
