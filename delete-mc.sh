#!/usr/bin/env bash

set -e

# ==========================================================
#        ୨୧ YUMEREIII'S MINECRAFT SERVER DELETE ୨୧
# ==========================================================

MC_DIR="$HOME/minecraft"
SESSION="minecraft"

# Color Codes
PINK=$'\e[95m'
LIGHTPINK=$'\e[38;5;213m'
CYAN=$'\e[96m'
GREEN=$'\e[92m'
YELLOW=$'\e[93m'
RED=$'\e[91m'
WHITE=$'\e[97m'
GRAY=$'\e[90m'
RESET=$'\e[0m'
BOLD=$'\e[1m'

banner() {
    clear
    echo -e "${LIGHTPINK}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                                                          ║"
    echo "║           ✿ MENU KHẨN CẤP: XOÁ SERVER MINECRAFT ✿       ║"
    echo "║                                                          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

tsu() {
    echo -e "${LIGHTPINK}♡${RESET} $1"
}

banner

echo -e "${RED}${BOLD}⚠ CẢNH BÁO CỰC KỲ NGUY HIỂM NÈ BAKA! ⚠${RESET}"
echo -e "${PINK}══════════════════════════════════════════════════════════${RESET}"
echo
echo -e " Hmph! Cậu có biết hành động này sẽ xoá ${RED}SẠCH BÁCH${RESET} thư mục này không:"
echo -e "   ${WHITE}${MC_DIR}${RESET}"
echo
echo -e " Toàn bộ công sức của chúng ta sẽ bốc hơi đó:"
echo -e "   ${CYAN}•${RESET} Thế giới (World)"
echo -e "   ${CYAN}•${RESET} Các Mod xịn xò"
echo -e "   ${CYAN}•${RESET} Cấu hình Config & Server properties"
echo -e "   ${CYAN}•${RESET} Nhật ký Logs"
echo -e "   ${CYAN}•${RESET} Bộ cài Fabric"
echo
echo -e "${PINK}══════════════════════════════════════════════════════════${RESET}"
echo

read -rp "Gõ 'DELETE' lẹ lên nếu thực sự muốn xoá (Đừng có hối hận đó!): " CONFIRM

if [ "$CONFIRM" != "DELETE" ]; then
    echo
    tsu "Hứ! Biết ngay là không dám xoá mà... Tự dưng làm Rei hú vía! Baka! >///<"
    echo -e "${GREEN}✓ Đã hủy thao tác xoá server thành công!${RESET}"
    exit 0
fi

echo
echo -e "${WHITE}${BOLD}〔 1 / 3 〕 ĐANG ÉP SERVER ĐI NGỦ... ${RESET}"

# Kiểm tra & Dọn dẹp tmux socket an toàn
if ! pgrep -u "$USER" -x tmux >/dev/null 2>&1; then
    rm -rf "/tmp/tmux-$(id -u)" 2>/dev/null || true
fi

if tmux has-session -t "$SESSION" 2>/dev/null; then

    tsu "Ngoan ngoãn lưu dữ liệu rồi tắt đi nào..."
    tmux send-keys -t "$SESSION" "save-all" Enter 2>/dev/null || true
    sleep 2
    tmux send-keys -t "$SESSION" "stop" Enter 2>/dev/null || true

    echo -e "${YELLOW}→ Đang đợi server dừng hẳn... Chờ chút đi!${RESET}"
    sleep 5

    tmux kill-session -t "$SESSION" 2>/dev/null || true
    echo -e "${GREEN}✓ Đã tắt tmux session rồi nhé.${RESET}"

else

    tsu "Ủa? Server có chạy đâu mà tắt?! Đúng là đồ ngốc..."

fi

rm -rf "/tmp/tmux-$(id -u)" 2>/dev/null || true

echo
echo -e "${WHITE}${BOLD}〔 2 / 3 〕 ĐANG TRUY TÌM TIẾN TRÌNH JAVA CÒN SÓT... ${RESET}"

if pkill -f "$MC_DIR/fabric-server-launch.jar" 2>/dev/null; then
    echo -e "${GREEN}✓ Đã tiễn tiến trình Java cứng đầu đi rồi!${RESET}"
else
    tsu "Không có tiến trình Java rác nào hết. Tốt lắm!"
fi

sleep 2

echo
echo -e "${WHITE}${BOLD}〔 3 / 3 〕 XOÁ QUẢNG THƯ MỤC MINECRAFT! ${RESET}"

if [ -d "$MC_DIR" ]; then

    rm -rf "$MC_DIR"
    echo -e "${GREEN}✓ Thư mục Minecraft đã bốc hơi hoàn toàn rồi!${RESET}"

else

    tsu "Thư mục vốn dĩ có tồn tại đâu? Cậu trêu Rei đấy à?!"

fi

echo
echo -e "${PINK}══════════════════════════════════════════════════════════${RESET}"
echo -e "${LIGHTPINK}${BOLD}            ✿ MÁY CHỦ ĐÃ BỊ XOÁ SẠCH SẼ! ✿             ${RESET}"
echo -e "${PINK}══════════════════════════════════════════════════════════${RESET}"
echo
tsu "Xoá xong hết rồi đó! Vừa lòng cậu chưa?!"
tsu "Nếu muốn cài lại từ đầu thì gõ lệnh này nè (Đừng có bắt Rei làm lại nhiều quá đó!):"
echo
echo -e "   ${GREEN}${BOLD}~/install-yumereiii.sh${RESET}"
echo
tsu "Hmph! Tạm biệt... Đừng có nhớ Rei quá đấy nha! >///<"
echo