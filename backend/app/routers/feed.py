from fastapi import APIRouter, HTTPException, Path
from app.services.feed_master_service import FeedMasterService

router = APIRouter(tags=["Feed Recommendation Base"])

@router.get("/api/feed")
@router.get("/api/v1/feed")
def get_all_feeds():
    """
    Returns all feed recommendations from feed_master.csv cached in memory.
    """
    feeds = FeedMasterService.get_all_feeds()
    return {
        "status": "success",
        "total": len(feeds),
        "data": feeds,
    }

@router.get("/api/feed/{breed_name}")
@router.get("/api/v1/feed/{breed_name}")
def get_feed_by_breed_name(breed_name: str = Path(..., description="Name of the breed to retrieve feed recommendation for")):
    """
    Returns feed recommendation for a specific breed from feed_master.csv.
    """
    feed_info = FeedMasterService.get_feed_by_breed_name(breed_name)
    if not feed_info:
        raise HTTPException(
            status_code=404,
            detail=f"Feed recommendation for breed '{breed_name}' not found in feed master knowledge base."
        )
    return {
        "status": "success",
        "data": feed_info,
    }
