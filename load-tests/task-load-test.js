import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 20 },
    { duration: '5m', target: 50 },
    { duration: '2m', target: 0 },
  ],
};

const BASE_URL =
  'http://cloud-task-manager-alb-1439355354.us-east-1.elb.amazonaws.com';

export default function () {
  http.get(`${BASE_URL}/tasks`);

  http.post(
    `${BASE_URL}/tasks`,
    JSON.stringify({
      title: 'Load Test Task',
      description: 'Created during k6 load test',
    }),
    {
      headers: {
        'Content-Type': 'application/json',
      },
    },
  );

  sleep(1);
}
