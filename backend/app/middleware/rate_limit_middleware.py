import time
from fastapi import Request, HTTPException
from starlette.middleware.base import BaseHTTPMiddleware

class RateLimitMiddleware(BaseHTTPMiddleware):
    def __init__(self, app, max_requests: int = 100, window_seconds: int = 60):
        super().__init__(app)
        self.max_requests = max_requests
        self.window_seconds = window_seconds
        self.client_records = {}

    async def dispatch(self, request: Request, call_next):
        client_ip = request.client.host if request.client else "127.0.0.1"
        now = time.time()

        if client_ip not in self.client_records:
            self.client_records[client_ip] = []

        # Filter timestamps outside window
        timestamps = [t for t in self.client_records[client_ip] if now - t < self.window_seconds]
        self.client_records[client_ip] = timestamps

        if len(timestamps) >= self.max_requests:
            raise HTTPException(status_code=429, detail="Too Many Requests. Rate limit exceeded.")

        self.client_records[client_ip].append(now)
        response = await call_next(request)
        return response
