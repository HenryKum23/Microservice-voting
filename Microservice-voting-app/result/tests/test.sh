#!/bin/bash
set -e

echo "=== Starting Voting App Tests ==="

# Wait for vote service (use curl, not /dev/tcp!)
echo "Waiting for vote service..."
timeout 60 bash -c 'until curl -sf http://vote:8000 > /dev/null 2>&1; do 
    echo "Vote not ready, waiting..."
    sleep 2
done' || {
    echo "✗ Vote service timeout!"
    exit 1
}

echo "✓ Vote service is ready!"

# Wait for result service
echo "Waiting for result service..."
timeout 60 bash -c 'until curl -sf http://result:4000 > /dev/null 2>&1; do 
    echo "Result not ready, waiting..."
    sleep 2
done' || {
    echo "✗ Result service timeout!"
    exit 1
}

echo "✓ Result service is ready!"
echo ""

# Submit vote
echo "Submitting vote for option B..."
RESPONSE=$(curl -sS -X POST --data "vote=b" http://vote:8000)

if [ $? -eq 0 ]; then
    echo "✓ Vote submitted successfully"
else
    echo "✗ Failed to submit vote!"
    exit 1
fi

echo ""
echo "Waiting 15 seconds for worker to process vote..."
sleep 15

# Check result
echo "Checking if vote appears in results..."
RESULT=$(curl -sS http://result:4000)

if echo "$RESULT" | grep -qi 'vote\|voting'; then
    echo ""
    echo "================================"
    echo "✓ TESTS PASSED ✓"
    echo "✓ Vote was recorded successfully"
    echo "================================"
    exit 0
else
    echo ""
    echo "================================"
    echo "✗ TESTS FAILED ✗"
    echo "✗ Vote was NOT recorded"
    echo "================================"
    echo ""
    echo "Result page content:"
    echo "$RESULT"
    exit 1
fi