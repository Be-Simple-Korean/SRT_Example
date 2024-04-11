const BASE_URL = "http://dpms.openobject.net:4132";

// 인증 코드 보내기
const API_SEND_AUTH_CODE = "/code?email=";
// 인증 코드 검증
const API_VERIFY_AUTH_CODE = "/verify";
// 회원가입
const API_SIGN_UP = "/signup";
// 로그인
const API_LOGIN = "/login";
// 메인
const API_SRT_INFO = "/srtInfo";
// 기차 조회
const API_SRT_LIST = "/srtList";
// 기차 예매
const API_SRT_RESERVE = "/reserve";

const SUCCESS_MESSAGE = "SUCCESS";

const FONT_NOTOSANS = "MyNotoSans";

const PREF_KEY_ID = "pref_id";
const PREF_KEY_NAME = "pref_name";
const PREF_KEY_STATION_INFO = "pref_station_info";