<template>
  <div class="content about-page">
    <h1>About HelloPerld</h1>
    <div class="about-content">
      <section>
        <h2>What is HelloPerld?</h2>
        <p>HelloPerld is a modern Mojolicious-based web application that demonstrates best practices for Perl web development.</p>
      </section>
      <section>
        <h2>Features</h2>
        <ul>
          <li>RESTful API endpoints with OpenAPI specification</li>
          <li>Multiple logging backends (Console, Database, JSON file)</li>
          <li>Health check endpoints for monitoring</li>
          <li>Swagger UI for API documentation</li>
          <li>Single-page application architecture with Vue 3</li>
        </ul>
      </section>
      <section>
        <h2>Technology Stack</h2>
        <ul>
          <li>Perl with Mojolicious framework</li>
          <li>Vue 3 for frontend interactivity</li>
          <li>PostgreSQL for database</li>
          <li>Docker for containerization</li>
        </ul>
      </section>
    </div>
  </div>
</template>

<style scoped>
.content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 80vh;
}

.about-page {
  align-items: flex-start;
  padding: 2rem;
  max-width: 800px;
  margin: 0 auto;
}

.about-page h1 {
  font-size: 36px;
  margin-bottom: 2rem;
  align-self: center;
  color: black;
}

.about-content {
  width: 100%;
}

.about-content section {
  margin-bottom: 2rem;
}

.about-content h2 {
  color: #2c3e50;
  font-size: 24px;
  margin-bottom: 1rem;
  border-bottom: 2px solid #3498db;
  padding-bottom: 0.5rem;
}

.about-content p {
  color: #333;
  line-height: 1.6;
  margin-bottom: 1rem;
}

.about-content ul {
  list-style: none;
  padding-left: 0;
}

.about-content ul li {
  color: #333;
  line-height: 1.8;
  padding-left: 1.5rem;
  position: relative;
}

.about-content ul li:before {
  content: "▸";
  color: #3498db;
  position: absolute;
  left: 0;
  font-weight: bold;
}
</style>
