---
permalink: /
layout: archive
title: "About Me"
author_profile: true
redirect_from:
  - /about/
  - /about.html
---

<h1 id="about-me">&#128663; About Me</h1>

I received my Ph.D. in Transportation Engineering from the School of Transportation, Southeast University, advised by Prof. Yanjie Ji. I was also a joint Ph.D. student at Nagoya University, advised by Prof. Tomio Miwa. I received my M.S. from Northern Arizona University, M.Eng. from Guilin University of Electronic Technology, and B.E. from Central South University.

My research centers on intelligent transportation systems, traffic modeling, travel behavior analysis, and data-driven decision support for urban mobility. I am currently interested in route choice modeling, traffic guidance and signal control, connected and autonomous vehicles, shared mobility, trajectory reconstruction, and machine learning for transportation systems.

<h1 id="news">&#128240; News</h1>

{% assign news_limit = site.homepage.news_limit | default: 4 %}
<ul>
{% for item in site.data.homepage.news limit: news_limit %}
  <li><em>{{ item.date }}</em>: {{ item.text }}</li>
{% endfor %}
</ul>

<h1 id="selected-publications">&#128204; Selected Publications <a href="/publications/">view all</a></h1>

{% assign publications_limit = site.homepage.selected_publications_limit | default: 5 %}
{% for publication in site.data.homepage.selected_publications limit: publications_limit %}
<div class="paper-box">
  <div class="paper-box-image">
    <div>
      <div class="badge">{{ publication.badge }}</div>
      <img src="{{ publication.image | relative_url }}" alt="{{ publication.image_alt }}" width="100%" draggable="false" />
    </div>
  </div>
  <div class="paper-box-text">
    <p><a href="{{ publication.url }}">{{ publication.title }}</a></p>
    <p>{{ publication.authors }}</p>
    <p>{{ publication.venue }}</p>
    {% if publication.doi %}
    <p><a href="{{ publication.doi }}" class="btn" role="button">DOI</a></p>
    {% endif %}
  </div>
</div>
{% endfor %}

<h1 id="services">&#129309; Services</h1>

- Reviewer for journals including *Transportation Research Part E*, *Transportation Research Part D*, *Journal of Transport Geography*, *IEEE Transactions on Intelligent Transportation Systems*, *IEEE ITS Magazine*, *Transportation Research Record*, *IET Intelligent Transport Systems*, and *Multimodal Transportation*.
- Member, China Society of Automotive Engineers (China-SAE).
- Student Member, IEEE.
