# Saki

Notion 데이터베이스를 백엔드로 쓰는 **CalDAV 서버(RFC 4791)**. Apple 캘린더 등 CalDAV
클라이언트가 Notion 에 저장된 일정을 iCalendar 리소스로 읽고 쓸 수 있다.

## 배포 (proxmox-env)

Komodo Stack 으로 배포되는 웹 서비스. `push → GHCR 빌드 → deploy-proxy 재배포 →
Traefik https://saki.oein.fyi`. 상태는 Notion 에 있어 로컬 볼륨이 없다.

- `Dockerfile` — Bun 런타임, `bun run src/index.ts` (포트 5232)
- `compose.yaml` — 이미지 + Traefik 라벨(`saki.oein.fyi`)
- `.github/workflows/deploy.yml` — 번들 검증 → GHCR 빌드/푸시 → deploy-proxy 재배포
- `.github/workflows/set-env.yml` — (수동) 런타임 시크릿 주입
- `.env.example` — 필요한 변수 목록(값 없음, 실제 값은 커밋 금지)

CalDAV base: `https://saki.oein.fyi/calendars/<CALDAV_USERNAME>/`

## 설정 (env)

`.env` 또는 Komodo env 로 주입 (`.env.example` 참고):
- `NOTION_TOKEN` — Notion integration 토큰
- `NOTION_DATABASE_ID` — 대상 Notion 데이터베이스 ID
- `CALDAV_USERNAME` / `CALDAV_PASSWORD` — CalDAV 인증 자격증명
- `PORT` — 서버 포트 (기본 5232)

## 개발

- `bun run src/index.ts` — 로컬 실행
- `npm run dev` — tsx watch 핫리로드
- `npx tsc --noEmit` — 타입 체크

## 아키텍처

상세는 [CLAUDE.md](CLAUDE.md) 참고. 요청 흐름: CalDAV 클라이언트 → Express(Digest/Basic
Auth) → CalDAV 핸들러 → Notion API.
