const https = require('https');
const fs = require('fs');

// .envファイルからAPIキーを読み込み
function loadEnvFile() {
  try {
    const envContent = fs.readFileSync('.env', 'utf8');
    const lines = envContent.split('\n');
    const env = {};
    
    lines.forEach(line => {
      const [key, value] = line.split('=');
      if (key && value) {
        env[key.trim()] = value.trim();
      }
    });
    
    return env;
  } catch (error) {
    console.error('Error reading .env file:', error.message);
    return {};
  }
}

// Places APIを使用してラーメン店を検索
function testPlacesAPI(apiKey) {
  const query = 'ラーメン';
  const location = '35.6762,139.6503'; // 東京駅の座標
  const radius = '5000'; // 5km範囲
  
  const url = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location}&radius=${radius}&keyword=${encodeURIComponent(query)}&key=${apiKey}`;
  
  console.log('Testing Google Places API...');
  console.log('API Key:', apiKey.substring(0, 10) + '...');
  console.log('Request URL:', url.replace(apiKey, 'API_KEY_HIDDEN'));
  console.log('\n--- API Response ---');
  
  https.get(url, (res) => {
    let data = '';
    
    res.on('data', (chunk) => {
      data += chunk;
    });
    
    res.on('end', () => {
      try {
        const response = JSON.parse(data);
        
        console.log('Status Code:', res.statusCode);
        console.log('Response Status:', response.status);
        
        if (response.status === 'OK') {
          console.log('✅ API Key is valid and working!');
          console.log(`Found ${response.results.length} ramen shops`);
          
          if (response.results.length > 0) {
            console.log('\nFirst 3 results:');
            response.results.slice(0, 3).forEach((place, index) => {
              console.log(`${index + 1}. ${place.name}`);
              console.log(`   Rating: ${place.rating || 'N/A'}`);
              console.log(`   Address: ${place.vicinity || 'N/A'}`);
              console.log('');
            });
          }
        } else {
          console.log('❌ API Error:');
          console.log('Error Status:', response.status);
          console.log('Error Message:', response.error_message || 'No error message provided');
          
          // 一般的なエラーの説明
          switch (response.status) {
            case 'REQUEST_DENIED':
              console.log('\n💡 Possible causes:');
              console.log('- API key is invalid or expired');
              console.log('- Places API is not enabled for this project');
              console.log('- API key restrictions are blocking the request');
              break;
            case 'OVER_QUERY_LIMIT':
              console.log('\n💡 Possible causes:');
              console.log('- Daily quota exceeded');
              console.log('- Rate limit exceeded');
              break;
            case 'INVALID_REQUEST':
              console.log('\n💡 Possible causes:');
              console.log('- Missing required parameters');
              console.log('- Invalid parameter values');
              break;
          }
        }
      } catch (error) {
        console.log('❌ Failed to parse JSON response:');
        console.log('Raw response:', data);
        console.log('Parse error:', error.message);
      }
    });
  }).on('error', (error) => {
    console.log('❌ Network error:', error.message);
  });
}

// メイン実行
const env = loadEnvFile();
const apiKey = env.GOOGLE_MAPS_API_KEY;

if (!apiKey) {
  console.log('❌ GOOGLE_MAPS_API_KEY not found in .env file');
  process.exit(1);
}

testPlacesAPI(apiKey);