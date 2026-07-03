# Saki — Notion 백엔드 CalDAV 서버 (Bun + Express)
FROM oven/bun:1-slim

WORKDIR /app

# 의존성 먼저 (레이어 캐시)
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile --production

# 앱 소스
COPY . .

# CalDAV HTTP 서버. 상태는 Notion 에 있으므로 로컬 영속 스토리지 불필요.
ENV PORT=5232
EXPOSE 5232

CMD ["bun", "run", "src/index.ts"]
